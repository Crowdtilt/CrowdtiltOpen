class BaseController < ApplicationController
  before_filter :check_initialized
  around_filter :scope_current_site # This depends on load_site and needs to run after

  def verify_admin
    if !current_user.has_role? :admin, @site
      redirect_to root_path, :flash => { :notice => "You must be an admin to access that page" }
   end
  end

private

  def check_initialized
    if !@site.initialized_flag
      if !user_signed_in?
        return redirect_to new_user_registration_path, :flash => { :error => "App is not initialized" }
      else
        begin
          @site.initialize_site(current_user)
        rescue => exception
          return redirect_to root_path, :flash => { :error => "An error occurred, please contact team@crowdhoster.com: #{exception.message}"}

        else
          return redirect_to admin_website_path, :flash => { :success => "Nice! Your app is now initialized."}
        end
      end
    end
  end

  def scope_current_site
    Site.current_id = @site? @site.id : nil
    yield
  ensure
    Site.current_id = nil
  end

end
