class Api::V0::BaseController < ActionController::Base
  serialization_scope nil
  before_filter :authenticate_api!

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  def authenticate_api!
    unless @settings = Settings.find_by_api_key(params[:api_key])
      head :unauthorized
    end
  end
end