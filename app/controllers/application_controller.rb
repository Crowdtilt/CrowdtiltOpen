require 'domainatrix'

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_multisite_enabled
  before_filter :load_site
  before_filter :set_default_mailer_host
  after_filter :store_location

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

private

  def check_multisite_enabled
    @multisite_enabled = Rails.configuration.multisite_enabled
    @central_domain = Rails.configuration.central_domain

    @request_domain, @request_host = lambda do |p|
      return p.domain + '.' + p.public_suffix, p.host
    end.call(Domainatrix.parse(request.url))

    @is_custom_domain = @request_domain != @central_domain
    @rewrite_domain = (Rails.env != 'development') && @is_custom_domain

    logger.info "Domain: #{@request_domain}"
    logger.info "Custom: #{@is_custom_domain}"
  end

  def load_site
    if @multisite_enabled
      load_site_multisite
    else
      load_site_non_multisite
    end
  end

  def load_site_multisite
    is_subdomain_of_custom = false
    if @is_custom_domain
      @site = Site.find_by_custom_domain(@request_host)
    else
      @site = Site.find_by_subdomain(request.subdomain)
      is_subdomain_of_custom = true if @site && @site.custom_domain
    end

    if !@site && (@is_custom_domain || request.subdomain != 'admin')
      logger.error "No site found! #{request.url}"
      return redirect_to root_url(:subdomain => 'admin', :host => @central_domain)
    end

    logger.info "Loading site... #{@site.to_log_info}" if @site

    if @site && @is_custom_domain && request.fullpath =~ /\/checkout\//
      logger.info "Redirecting to secure payment page..."
      return redirect_to root_url(:subdomain => @site.subdomain, :host => @central_domain) + request.fullpath.sub('/', '')
    end

    if is_subdomain_of_custom
      logger.info "Redirecting to custom domain..."
      return redirect_to root_url(:host => @site.custom_domain) + request.fullpath.sub('/', ''), :status => 301 unless (request.fullpath =~ /\/admin/ || request.fullpath =~ /\/checkout\//)
    end

  end

  def load_site_non_multisite
    @site = Site.first_or_create!(:subdomain => '')
    logger.info "Loading site... #{@site.to_log_info}" if @site
  end

  def set_default_mailer_host
    ActionMailer::Base.default_url_options = {:host => request.host_with_port}
  end

  def store_location
    # store last url as long as it isn't an /account path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/account/
  end

end
