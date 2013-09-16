class Multisite::SitesController < Multisite::BaseController
  before_filter :authenticate_user!, :except => [:new]

  def new
    if !user_signed_in?
      return redirect_to new_user_registration_path
    end

    @site = Site.new
  end

  def create
    @site = Site.new(params[:site])

    # Pass through current_user as virtual attribute for after_create callback
    @site.admin_user = current_user

    # Check if the new settings pass validations...if not, re-render form and display errors in flash msg
    if !@site.valid?
      message = ''
      @site.errors.each {|key, error| message += key.to_s.humanize + " " + error.to_s + ", "}
      logger.info message
      flash.now[:error] = message[0...-2]
      return render action: "new"
    end
    
    begin
      @site.save
    rescue => exception
      flash.now[:error] = "An error occurred, please contact team@crowdhoster.com: #{exception.message}"
      return render action: "new"
    end

    redirect_to root_url(:subdomain => @site.subdomain)
  end

  def update
    @site = Site.find(params[:id])
    session[:site_id] = @site.id

    @site.update_attributes(subdomain: params[:site][:subdomain], custom_domain: params[:site][:custom_domain])

    if !current_user.has_role? :admin, @site
      return redirect_to multisite_sites_path, flash: {error: "You must be an admin to edit site settings."}
    end

    if !@site.valid?
      message = ''
      @site.errors.each {|key, error| message += key.to_s.humanize + " " + error.to_s + ", "}
      logger.info message
      return redirect_to multisite_sites_path, flash: {error: message[0...-2]}
    end

    @site.save
    return redirect_to multisite_sites_path, flash: {success: "Site updated!"}

  end

  def index
    @sites = Site.with_role(:admin, current_user).uniq_by(&:subdomain)

    if session[:site_id]
      @site_id = session[:site_id]
      session.delete(:site_id)
    end
  end

end
