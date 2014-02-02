class AdminController < ApplicationController
  include AdminMixin
  layout "admin"
  before_filter :authenticate_user!
  before_filter :verify_admin
  before_filter :set_ct_env, only: [:admin_bank_account, :create_admin_bank_account, :delete_admin_bank_account, :ajax_verify]

  def admin_dashboard
    redirect_to admin_campaigns_url, flash: flash
  end

  def admin_homepage
    #Handle the form submission if request is PUT
    if request.put?
      if @settings.update_attributes(params[:settings])
        flash.now[:success] = "Homepage successfully updated!"
      else
        flash.now[:error] = @settings.errors.full_messages.join(', ')
      end
    end
    create_breadcrumb(['Homepage', admin_homepage_path])
  end

  def admin_site_settings
    #Handle the form submission if request is PUT
    if request.put?
      if @settings.update_attributes(params[:settings])
        flash.now[:success] = "Site settings successfully updated!"
      else
        flash.now[:error] = @settings.errors.full_messages.join(', ')
      end
    end
    create_breadcrumb(['Site Settings', admin_site_settings_path])
  end

  def admin_customize
    #Handle the form submission if request is PUT
    if request.put?
      if @settings.update_attributes(params[:settings])
        flash.now[:success] = "Customizations successfully applied!"
      else
        flash.now[:error] = @settings.errors.full_messages.join(', ')
      end
    end
    create_breadcrumb(['Customize', admin_customize_path])
  end

  def admin_processor_setup
    if request.post?
      flash.now[:error] = "Missing API credentials" and return if params[:ct_prod_api_key].blank? || params[:ct_prod_api_secret].blank?
      if @settings.activate_payments(params[:ct_prod_api_key], params[:ct_prod_api_secret])
        flash.now[:success] = "Your payment processor is all set up!"
      else
        flash.now[:error] = "Could not activate payment processing. Please double-check your API credentials."
      end
    end
    create_breadcrumb(['Payment Processor', admin_processor_setup_path])
  end

  def create_admin_bank_account
    if params[:ct_bank_id].blank?
      flash = { :warning => "Looks like you have JavaScript disabled. JavaScript is required for bank account setup." }
    else
      begin
        bank = {
          id: params[:ct_bank_id]
        }
        Crowdtilt.post('/users/' + @ct_admin_id + '/banks/default', {bank: bank})
      rescue => exception
        flash = { :error => "An error occurred, please contact team@crowdhoster.com: #{exception.message}" }
      else
        flash = { :success => "Your bank account is all set up!" }
      end
    end
    redirect_to admin_bank_account_url, :status => 303, :flash => flash
  end

  def admin_bank_account
    unless @settings.payments_activated?
      redirect_to admin_processor_setup_url, flash: { info: "Please set up your payment processor before providing your bank details" } and return
    end
    @bank = {}
    begin
      response = Crowdtilt.get('/users/' + @ct_admin_id + '/banks/default')
    rescue => exception # response threw an error, default bank may not be set up
      # do nothing
    else # response is good, check for default bank
      if response['bank'] # default bank is already set up
        @bank = response['bank']
      else
        flash.now[:error] = "An error occurred, please contact team@crowdhoster.com" # this should never happen
      end
    end
    create_breadcrumb(['Bank Setup', admin_bank_account_path])
  end

  def delete_admin_bank_account
    begin
      response = Crowdtilt.get('/users/' + @ct_admin_id + '/banks/default')
    rescue => exception
        flash = { :warning => "No default bank account" }
    else
      begin
        Crowdtilt.delete('/users/' + @ct_admin_id + '/banks/' + response['bank']['id'])
      rescue => exception
        flash = { :error => "An error occurred, please contact team@crowdhoster.com: #{exception.message}" }
      else
        flash = { :success => "Bank account deleted successfully" }
      end
    end
    redirect_to admin_bank_account_url, :status => 303, :flash => flash
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
        flash.now[:error] = "Could not save notification settings. Please try again!"
      end
    end
    create_breadcrumb(['Notification Settings', admin_notification_setup_path])
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
