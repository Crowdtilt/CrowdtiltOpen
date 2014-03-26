class Admin::CampaignsController < ApplicationController
  include AdminMixin
  layout "admin"
  before_filter :authenticate_user!
  before_filter :verify_admin
  before_filter { |c| c.create_breadcrumb ['Campaigns', admin_campaigns_path] }

  def index
    @campaigns = Campaign.order("created_at ASC")
  end

  def new
    @campaign = Campaign.new
    create_breadcrumb(['New Campaign', new_admin_campaign_path])
  end

  def copy
    old_campaign = Campaign.find(params[:id])
    @campaign = old_campaign.dup
    @campaign.expiration_date = Time.now + 30.days
    @campaign.published_flag = false
    @campaign.production_flag = false

    begin
      campaign = {
        title: @campaign.name,
        tilt_amount: @campaign.goal_dollars*100,
        expiration_date: @campaign.expiration_date,
        user_id: @settings.ct_sandbox_admin_id,
        billing_statement_text: @settings.billing_statement_text
      }
      Crowdtilt.sandbox
      response = Crowdtilt.post('/campaigns', {campaign: campaign})
    rescue => exception
      redirect_to admin_campaigns, :flash => { :error => "Could not copy campaign" }
    else
      @campaign.update_api_data(response['campaign'])
      @campaign.save
    end

    # Completely refresh the FAQs
    old_campaign.faqs.each do |faq|
      @campaign.faqs.create question: faq.question, answer: faq.answer
    end

    # Completely refresh the rewards
    old_campaign.rewards.each do |reward|
      @campaign.rewards.create title: reward.title,
                               image_url: reward.image_url,
                               description: reward.description,
                               delivery_date: reward.delivery_date,
                               number: reward.number,
                               price: reward.price,
                               collect_shipping_flag: reward.collect_shipping_flag,
                               include_claimed: reward.include_claimed
    end

    render action: "edit"
  end

  def create
    is_default = params[:campaign].delete :is_default
    @campaign = Campaign.new(params[:campaign])

    if !@campaign.valid?
      flash.now[:error] = @campaign.errors.full_messages.join(', ')
      render action: "new"
      return
    end

     # Set the campaign user id
     ct_user_id = @campaign.production_flag ? @settings.ct_production_admin_id : @settings.ct_sandbox_admin_id

    # calculate the goal amount (in case of a tilt by orders campaign)
    @campaign.set_goal

    # Create a corresponding campaign on the Crowdtilt API
    # If it fails, echo the error message sent by the API back to the user
    # If successful, save the campaign
    begin
      campaign = {
        title: @campaign.name,
        tilt_amount: (@campaign.goal_dollars*100).to_i,
        expiration_date: @campaign.expiration_date,
        user_id: ct_user_id,
        billing_statement_text: @settings.billing_statement_text
      }
      @campaign.production_flag ? Crowdtilt.production(@settings) : Crowdtilt.sandbox
      response = Crowdtilt.post('/campaigns', {campaign: campaign})
    rescue => exception
      flash.now[:error] = exception.to_s
      render action: "new"
      return
    else
      @campaign.update_api_data(response['campaign'])
      @campaign.save

      # Now that we've created the campaign, create new FAQs if any were provided
      if params.has_key?(:faq)
        params[:faq].each do |faq|
          if !faq['question'].empty?
            @campaign.faqs.create question: faq['question'], answer: faq['answer']
          end
        end
      end

      # Now that we've created the campaign, create new Reward Levels if any were provided
      if params.has_key?(:reward)
        params[:reward].each do |reward|
          unless reward['delete'] && reward['delete'] == 'delete'
              @campaign.rewards.create title: reward['title'],
                                       image_url: reward['image_url'],
                                       description: reward['description'],
                                       delivery_date: reward['delivery_date'],
                                       number: reward['number'].to_i,
                                       price: reward['price'].to_f,
                                       collect_shipping_flag: reward['collect_shipping_flag'],
                                       include_claimed: reward['include_claimed']
          end
        end
      end

      # Check again for campaign validity now that we've added faqs and rewards
      if !@campaign.valid?
        flash.now[:error] = @campaign.errors.full_messages.join(', ')
        render action: "new"
        return
      end

      # Set default campaign
      if(is_default == "1")
        @settings.default_campaign_id = @campaign.id
      elsif (@settings.default_campaign_id == @campaign.id)
        @settings.default_campaign_id = nil
      end
      @settings.save

      redirect_to campaign_home_url(@campaign), :flash => { :success => "Campaign created!" }
      return
    end
  end

  def edit
    @campaign = Campaign.find(params[:id])
    create_breadcrumb(['Edit Campaign', edit_admin_campaign_path(@campaign)])
  end

  def update
    @campaign = Campaign.find(params[:id])

    is_default = params[:campaign].delete :is_default

    if(is_default =="1")
      @settings.default_campaign_id = @campaign.id
    elsif (@settings.default_campaign_id == @campaign.id)
      @settings.default_campaign_id = nil
    end
    @settings.save

    # We don't immediately update the campaign, becuase the Crowdtilt API may still fail a validation
    @campaign.assign_attributes(params[:campaign])

    # Completely refresh the FAQ data
    @campaign.faqs.destroy_all
    if params.has_key?(:faq)
      params[:faq].each do |faq|
        if !faq['question'].empty?
          @campaign.faqs.create question: faq['question'], answer: faq['answer']
        end
      end
    end

    # Update the Reward Levels
    if params.has_key?(:reward)
      params[:reward].each do |reward|
        if reward['delete'] && reward['delete'] == 'delete'
          if reward['id']
            r = Reward.find(reward['id'])
            r.destroy if(r.payments.length == 0)
          end
        else
          if reward['id']
              r = Reward.find(reward['id'])
              r.title = reward['title']
              r.image_url = reward['image_url']
              r.description = reward['description']
              r.delivery_date = reward['delivery_date']
              r.number = reward['number'].to_i
              r.price = reward['price'].to_f
              r.collect_shipping_flag = reward['collect_shipping_flag']
              r.include_claimed = reward['include_claimed']
              unless r.save
                flash.now[:error] = "A reward field is missing or invalid"
                render action: "edit"
                return
              end
          else
            @campaign.rewards.create title: reward['title'],
                                     image_url: reward['image_url'],
                                     description: reward['description'],
                                     delivery_date: reward['delivery_date'],
                                     number: reward['number'].to_i,
                                     price: reward['price'].to_f,
                                     collect_shipping_flag: reward['collect_shipping_flag'],
                                     include_claimed: reward['include_claimed']
          end
        end
      end
    end

    if !@campaign.valid?
      flash.now[:error] = @campaign.errors.full_messages.join(', ')
      render action: "edit"
      return
    end

    # Set the campaign user id
     ct_user_id = @campaign.production_flag ? @settings.ct_production_admin_id : @settings.ct_sandbox_admin_id

    #if campaign has been promoted to production, delete all sandbox payments
    if @campaign.production_flag && @campaign.production_flag_changed?
      @campaign.payments.destroy_all
    end

    # calculate the goal amount (in case of a tilt by orders campaign)
    @campaign.set_goal

    # Update the corresponding campaign on the Crowdtilt API
    # If it fails, echo the error message sent by the API back to the user
    # If successful, save the campaign
    begin
      campaign = {
        title: @campaign.name,
        tilt_amount: (@campaign.goal_dollars*100).to_i,
        expiration_date: @campaign.expiration_date,
        billing_statement_text: @settings.billing_statement_text
      }
      # If the campaign has been promoted to production, create a new campaign on the Crowtilt API
      if @campaign.production_flag && @campaign.production_flag_changed?
        campaign[:user_id] = ct_user_id
        Crowdtilt.production(@settings)
        response = Crowdtilt.post('/campaigns', {campaign: campaign})
      else
        @campaign.production_flag ? Crowdtilt.production(@settings) : Crowdtilt.sandbox
        response = Crowdtilt.put('/campaigns/' + @campaign.ct_campaign_id, {campaign: campaign})
      end
    rescue => exception
      flash.now[:error] = exception.to_s
      render action: "edit" and return
    else
      @campaign.update_api_data(response['campaign'])
      @campaign.save
      redirect_to campaign_home_url(@campaign), :flash => { :success => "Campaign updated!" } and return
    end
  end

  def payments
#     @campaign = Campaign.find(params[:id])
#     page = params[:page] || 1
#
#     #Check if the user is searching for a certain payment_id
#     if params.has_key?(:payment_id) && !params[:payment_id].blank?
#       begin
#         response = Crowdtilt.get('/campaigns/' + @campaign.ct_campaign_id + '/payments/' + params[:payment_id])
#       rescue => exception
#         #This means the payment_id wasn't found, so go ahead and grab all payments
#         response = Crowdtilt.get('/campaigns/' + @campaign.ct_campaign_id + '/payments?page=1&per_page=50')
#         @contributors = response['payments']
#         @page = response['pagination']['page'].to_i
#         @total_pages = response['pagination']['total_pages'].to_i
#         flash.now[:error] = "Contributor not found for " + params[:payment_id]
#       else
#         @contributors = [response['payment']]
#         @page = @total_pages = 1
#       end
#     else
#       response = Crowdtilt.get('/campaigns/' + @campaign.ct_campaign_id + "/payments?page=#{page}&per_page=50")
#       @contributors = @contributors = response['payments']
#       @page = response['pagination']['page'].to_i
#       @total_pages = response['pagination']['total_pages'].to_i
#     end
    @campaign = Campaign.find(params[:id])
    if params.has_key?(:payment_id) && !params[:payment_id].blank?
      payment = Payment.find_by_ct_payment_id(params[:payment_id].strip)
      if payment
        @payments = [payment]
      else
        @payments = @campaign.payments.completed.order("created_at ASC")
        flash.now[:error] = "Contributor not found for " + params[:payment_id]
      end
    elsif params.has_key?(:email) && !params[:email].blank?
      @payments = @campaign.payments.completed.where("lower(email) = ?", params[:email].downcase)
      if @payments.blank?
        @payments = @campaign.payments.completed.order("created_at ASC")
        flash.now[:error] = "Contributor not found for " + params[:email]
      end
    else
      @payments = @campaign.payments.completed.order("created_at ASC")
    end

    create_breadcrumb(['Payments', admin_campaigns_payments_path(@campaign)])
    respond_to do |format|
      format.html
      format.csv { send_data @payments.to_csv, filename: "#{@campaign.name}.csv" }
    end
  end
end
