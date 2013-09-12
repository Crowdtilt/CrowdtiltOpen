class PagesController < BaseController

  def index
    @campaigns = Campaign.order("created_at ASC")
    render 'theme/views/homepage'
  end

end
