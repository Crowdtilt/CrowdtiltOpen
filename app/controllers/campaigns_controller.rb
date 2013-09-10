class CampaignsController < ApplicationController
  before_filter :load_campaign
  before_filter :check_published
  before_filter :check_exp, :except => [:home, :checkout_confirmation]

  # The load_campaign before filter grabs the campaign object from the db
  # and makes it available to all routes

  def home
    render 'theme/views/campaign'
  end

  def checkout_amount
    @reward = false
    if params.has_key?(:reward) && params[:reward].to_i != 0
      @reward = Reward.find_by_id(params[:reward])
      unless @reward && @reward.campaign_id == @campaign.id && !@reward.sold_out?
        @reward = false
        flash.now[:notice] = "Please select a different reward"
      end
    end
  end

  def checkout_payment
    @reward = false
    if @campaign.payment_type == "fixed"
      if params.has_key?(:quantity)
        @quantity = params[:quantity].to_i
        @amount = ((@quantity * @campaign.fixed_payment_amount.to_f)*100).ceil/100.0
      else
        redirect_to checkout_amount_url(@campaign), flash: { error: "Invalid quantity!" }
        return
      end
    elsif params.has_key?(:amount) && params[:amount].to_f >= @campaign.min_payment_amount
      @amount = ((params[:amount].to_f)*100).ceil/100.0
      @quantity = 1

      if params.has_key?(:reward) && params[:reward].to_i != 0
        begin
          @reward = Reward.find(params[:reward])
        rescue => exception
          redirect_to checkout_amount_url(@campaign), flash: { error: "Please select a different reward" }
          return
        end
        unless @reward && @reward.campaign_id == @campaign.id && !@reward.sold_out? && @reward.price <= @amount
          redirect_to checkout_amount_url(@campaign), flash: { error: "Invalid reward!" }
          return
        end
      end

    else
      redirect_to checkout_amount_url(@campaign), flash: { error: "Invalid amount!" }
      return
    end

    @fee = (@campaign.apply_processing_fee)? ((@amount * (Rails.configuration.processing_fee.to_f/100))*100).ceil/100.0 : 0
    @total = @amount + @fee

  end

  def checkout_confirmation

    ct_user_id = params[:ct_user_id]
    ct_card_id = params[:ct_card_id]
    fullname = params[:fullname]
    email = params[:email]
    billing_postal_code = params[:billing_postal_code]

    #calculate amount and fee in cents
    amount = (params[:amount].to_f*100).ceil
    fee = (amount * (Rails.configuration.processing_fee.to_f/100)).ceil
    quantity = params[:quantity].to_i

    #Shipping Info
    address_one = params.has_key?(:address_one) ? params[:address_one] : ''
    address_two = params.has_key?(:address_two) ? params[:address_two] : ''
    city = params.has_key?(:city) ? params[:city] : ''
    state = params.has_key?(:state) ? params[:state] : ''
    postal_code = params.has_key?(:postal_code) ? params[:postal_code] : ''
    country = params.has_key?(:country) ? params[:country] : ''

    #Additional Info
    additional_info = params.has_key?(:additional_info) ? params[:additional_info] : ''

    @reward = false
    if params[:reward].to_i != 0
      @reward = Reward.find_by_id(params[:reward])
      unless @reward && @reward.campaign_id == @campaign.id && !@reward.sold_out? && @reward.price <= amount
        redirect_to checkout_amount_url(@campaign), flash: { error: "Please select a different reward" } and return
      end
    end

    # Apply the processing fee to the user or the admin
    if @campaign.apply_processing_fee
      user_fee_amount = fee
      admin_fee_amount = 0
    else
      user_fee_amount = 0
      admin_fee_amount = fee
    end

    # TODO: Check to make sure the amount is valid here

    # Create the payment record in our db, if there are errors, redirect the user
    @payment = @campaign.payments.new fullname: fullname,
                                      email: email,
                                      billing_postal_code: billing_postal_code,
                                      quantity: quantity,
                                      address_one: address_one,
                                      address_two: address_two,
                                      city: city,
                                      state: state,
                                      postal_code: postal_code,
                                      country: country,
                                      additional_info: additional_info

    if !@payment.valid?
      message = ''
      @payment.errors.each {|key, error| message += key.to_s.humanize + " " + error.to_s + ", "}
      redirect_to checkout_amount_url(@campaign), flash: { error: message[0...-2] } and return
    end

    # Execute the payment via the Crowdtilt API, if it fails, redirect user
    begin
      payment = {
        amount: amount,
        user_fee_amount: user_fee_amount,
        admin_fee_amount: admin_fee_amount,
        user_id: ct_user_id,
        card_id: ct_card_id,
        metadata: {
          fullname: fullname,
          email: email,
          billing_postal_code: billing_postal_code,
          quantity: quantity,
          reward: @reward ? @reward.id : 0,
          additional_info: additional_info
        }
      }
      @campaign.production_flag ? Crowdtilt.production : Crowdtilt.sandbox

      logger.info "CROWDTILT API REQUEST: /campaigns/#{@campaign.ct_campaign_id}/payments"
      logger.info payment

      response = Crowdtilt.post('/campaigns/' + @campaign.ct_campaign_id + '/payments', {payment: payment})

      logger.info "CROWDTILT API RESPONSE:"
      logger.info response
    rescue => exception
      logger.info "ERROR WITH POST TO /payments: #{exception.message}"
      redirect_to checkout_amount_url(@campaign), flash: { error: "There was an error processing your payment, please try again" } and return
    end

    # Associate payment with reward
    @reward.payments << @payment if @reward

    # Sync payment data
    @payment.update_api_data(response['payment'])
    @payment.save

    # Sync campaign data
    @campaign.update_api_data(response['payment']['campaign'])
    @campaign.save

    # Send a confirmation email
    begin
      UserMailer.payment_confirmation(@payment, @campaign).deliver
    rescue => exception
      logger.info "ERROR WITH EMAIL RECEIPT: #{exception.message}"
    end

  end

  private

  def load_campaign
    @campaign = Campaign.find(params[:id])
  end

  def check_published
    if !@campaign.published_flag
      unless user_signed_in? && current_user.admin?
        redirect_to root_url, :flash => { :error => "Campaign is no longer available" }
      end
    end
  end

  def check_exp
    if @campaign.expired?
      redirect_to campaign_home_url(@campaign), :flash => { :error => "Campaign is expired!" }
    end
  end

end
