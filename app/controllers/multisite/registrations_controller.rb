class Multisite::RegistrationsController < Devise::RegistrationsController
  layout 'multisite/multisite'
  skip_filter :check_initialized

  def new
    @site = Site.new
    resource = build_resource({})
    render 'multisite/sites/new'
  end

  def create
    resource = build_resource
    @site = Site.new(params[:site])
    
    @site.admin_user = resource

    message = ''

    if !resource.valid?
      resource.errors.each {|key, error| message += key.to_s.humanize + " " + error.to_s + ", "}
    end

    if !@site.valid?
      @site.errors.each {|key, error| message += key.to_s.humanize + " " + error.to_s + ", "}
    end

    if message != ''
      clean_up_passwords resource
      logger.info message
      flash.now[:error] = message[0...-2]
      render 'multisite/sites/new'
      return
    end

    resource.save!

    set_flash_message :notice, :signed_up if is_navigational_format?
    sign_up(resource_name, resource)

    begin
      @site.save
    rescue => exception
      flash.now[:error] = "An error occurred, please contact team@crowdhoster.com: #{exception.message}"
      render action: 'multisite/sites/new'
      return
    end

    redirect_to root_url(:subdomain => @site.subdomain)
  end

protected

  def after_update_path_for(resource)
    user_settings_path
  end

end
