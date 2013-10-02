class AdminController < ApplicationController
  layout "admin"
  before_filter :authenticate_user!
  before_filter :verify_admin
  before_filter :set_ct_env, only: [:admin_bank_setup, :ajax_verify]

  def admin_website
    #Handle the form submission if request is PUT
    if request.put?
      if @settings.update_attributes(params[:settings])
        flash.now[:success] = "Website settings successfully updated!"
      else
        message = ''
        @settings.errors.each do |key, error|
          message = message + key.to_s.humanize + ' ' + error.to_s + ', '
        end
        flash.now[:error] = message[0...-2]
      end
    end
  end

  def admin_processor_setup
    if request.post?
      flash.now[:error] = "Invalid credentials" and return if params[:ct_prod_api_key].blank? || params[:ct_prod_api_secret].blank?
      if @settings.activate_payments(params[:ct_prod_api_key], params[:ct_prod_api_secret])
        flash.now[:success] = "Your payment processor is all set up!"
      else
        flash.now[:error] = "Invalid credentials"
      end
    end
  end

  def admin_bank_setup
    redirect_to admin_processor_setup_url, flash: { error: "Please set up your payment processor before providing your bank details" } and return unless @settings.payments_activated?
    @bank = {}
    begin
      response = Crowdtilt.get('/users/' + @ct_admin_id + '/banks/default')
    rescue => exception # response threw an error, default bank may not be set up
      if request.post?
        if params[:ct_bank_id].blank?
          flash.now[:error] = "An error occurred, please try again" and return
        else
          begin
            bank = {
              id: params[:ct_bank_id]
            }
            response = Crowdtilt.post('/users/' + @ct_admin_id + '/banks/default', {bank: bank})
          rescue => exception
            flash.now[:error] = exception.message and return
          else
            @bank = response['bank']
          end
        end
      end
    else # response is good, check for default bank
      if response['bank'] # default bank is already set up
        @bank = response['bank']
      else
        flash.now[:error] = "An error occurred, please contact team@crowdhoster.com" # this should never happen
      end
    end
  end

  def ajax_verify
    if params[:name].blank? || params[:phone].blank? || params[:street_address].blank? || params[:postal_code].blank? || params[:dob].blank?
      render text: "error" and return #not all fields filled out
    else
      begin
        response = Crowdtilt.get('/users/' + @ct_admin_id)
      rescue => exception
        render text: "error" and return #failed to verify through Crowdtilt API
      end
      if response['user']['is_verified'] != 1
        begin
          verification = {
            name: params[:name],
            phone_number: params[:phone],
            street_address: params[:street_address],
            postal_code: params[:postal_code],
            dob: params[:dob]
          }
          response = Crowdtilt.post('/users/' + @ct_admin_id + '/verification', {verification: verification})
        rescue => exception
          render text: "error" #failed to verify through Crowdtilt API
        else
          render text: "success" #successfully verified through Crowdtilt API
        end
      else
        render text: "success"  #already verified
      end
    end
  end

  def admin_notification_setup
    if request.put?
      if current_user.update_attributes(params[:user])
        flash.now[:success] = "Notification settings saved!"
      else
        flash.now[:error] = "There was an error saving your notification settings. Please try again!"
      end
    end
  end

private

  def set_ct_env
    if Rails.env.production?
      Crowdtilt.production(@settings)
      @ct_admin_id = @settings.ct_production_admin_id
    else
      Crowdtilt.sandbox
      @ct_admin_id = @settings.ct_sandbox_admin_id
    end
  end

end
