class RegistrationsController < Devise::RegistrationsController
  skip_filter :check_initialized

protected

  def after_update_path_for(resource)
    user_settings_path
  end

end
