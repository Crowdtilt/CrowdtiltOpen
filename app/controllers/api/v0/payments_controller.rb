class Api::V0::PaymentsController < Api::V0::BaseController
  ALLOWED_ORDER_BY_ATTRIBUTES = ['created_at', 'updated_at', 'ct_payment_id', 'status']
  
  def index
    campaign = Campaign.find_by_id!(params[:campaign_id])
    resource = ApiResource.new(campaign.payments, params)
    resource.apply_filters!    
    
    render json: resource.relation
  end
  
  private
  
  class ApiResource < Struct.new(:relation, :params)
    def apply_filters!
      self.relation = apply_limit!(relation) if apply_limit?
      self.relation = apply_order!(relation) if apply_order?
    end
    
    def apply_limit!(relation)
      relation.limit(params[:limit])
    end

    def apply_order!(relation)
      relation.order("#{params[:order_by]} #{order_direction}")
    end
    
    def apply_order?
      String(params[:order_by]).in?(ALLOWED_ORDER_BY_ATTRIBUTES)
    end
    
    def apply_limit?
      params[:limit].present?
    end

    private
    
    def order_direction
      params[:order_direction] == 'asc' ? 'asc' : 'desc'
    end
  end
end
