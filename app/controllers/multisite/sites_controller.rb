class Multisite::SitesController < Multisite::BaseController
  before_filter :authenticate_user!

  def new
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
      render action: "new"
      return
    end
    
    begin
      @site.save
    rescue => exception
      flash.now[:error] = "An error occurred, please contact team@crowdhoster.com: #{exception.message}"
      render action: "new"
      return
    end

    redirect_to root_url(:subdomain => @site.subdomain)
  end

  def index
    @sites = Site.with_role(:admin, current_user)
  end

end
