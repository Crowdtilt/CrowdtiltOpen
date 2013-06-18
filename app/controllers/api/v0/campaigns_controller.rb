class Api::V0::CampaignsController < Api::V0::BaseController
  def show
    render json: Campaign.find(params[:id])
  end
end