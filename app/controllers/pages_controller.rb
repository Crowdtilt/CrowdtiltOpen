class PagesController < ApplicationController
  before_filter :check_init

  def index
    @campaigns = Campaign.order("created_at ASC")
    render 'theme/views/homepage'
  end

end
