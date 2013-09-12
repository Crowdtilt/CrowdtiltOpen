class RegistrationsController < Devise::RegistrationsController
  skip_filter :check_initialized

  def edit
    if @multisite_enabled
      return redirect_to user_settings_url(:subdomain => 'admin', :host => @central_domain), :status => 301
    else
      super
    end
  end

protected

  def after_update_path_for(resource)
    user_settings_path
  end

end
