class PagesController < ApplicationController
  before_filter :check_init

  def index
    if @settings.default_campaign
      redirect_to campaign_home_url(@settings.default_campaign)
    else
      @campaigns = Campaign.order("created_at ASC")
      render 'theme/views/homepage'
    end
  end
end
