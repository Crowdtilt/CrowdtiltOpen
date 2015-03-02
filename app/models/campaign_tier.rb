class CampaignTier < ActiveRecord::Base
  attr_accessible :campaign_id, :min_users, :price_at_tier
  belongs_to :campaign

  def pct_off
  	((self.campaign.base_price - self.price_at_tier) / self.campaign.base_price) * 100.0
  end

  def pct_complete
  	orders = self.campaign.orders
  	(1.0 * [orders, self.min_users].min / self.min_users) * 100.0
  end
end
