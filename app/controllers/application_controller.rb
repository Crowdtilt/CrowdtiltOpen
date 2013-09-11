class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_multisite_enabled
  before_filter :load_site
  before_filter :check_initialized
  before_filter :set_default_mailer_host
  after_filter :store_location
  around_filter :scope_current_site # This depends on load_site and needs to run after

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def verify_admin
    if !current_user.has_role? :admin, @site
      redirect_to root_path, :flash => { :notice => "You must be an admin to access that page" }
   end
  end

private

  def check_multisite_enabled
    @multisite_enabled = Rails.configuration.multisite_enabled
  end

  def load_site
    @site = Site.find_by_subdomain(request.subdomain)

    if !@site && request.subdomain != 'admin'
      if @multisite_enabled
        return redirect_to root_url(:subdomain => 'admin')
      else
        @site = Site.first_or_create!(:subdomain => '')
      end
    end

  end

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

  def set_default_mailer_host
    ActionMailer::Base.default_url_options = {:host => request.host_with_port}
  end

  def store_location
    # store last url as long as it isn't an /account path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/account/
  end

end
