class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :load_site, :set_default_mailer_host
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

  def load_site
    @site = Site.find_by_subdomain(request.subdomain)

    if !@site
      redirect_to root_url(:subdomain => 'admin')
    end
  end

  def scope_current_site
    Site.current_id = @site.id
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
