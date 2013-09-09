class Multisite::SitesController < Multisite::BaseController

  def new
    @site = Site.new
  end

  def create
    @site = Site.new(params[:site])

    # Check if the new settings pass validations...if not, re-render form and display errors in flash msg
    if !@site.valid?
      message = ''
      @site.errors.each {|key, error| message += key.to_s.humanize + " " + error.to_s + ", "}
      logger.info message
      flash.now[:error] = message[0...-2]
      render action: "new"
      return
    end
    
    @site.save

    redirect_to root_url(:subdomain => @site.subdomain)
  end

  def index
    @sites = Site.all
  end

end
