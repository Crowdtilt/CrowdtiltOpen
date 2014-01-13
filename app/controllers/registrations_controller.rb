class RegistrationsController < Devise::RegistrationsController

  def create
    super
    sign_in current_user
  end
  
  protected

    def after_update_path_for(resource)
      user_settings_path
    end
end