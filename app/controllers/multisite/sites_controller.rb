class Multisite::SitesController < Multisite::BaseController

  def new
    @settings = Settings.new
  end

  def create
  end

end
