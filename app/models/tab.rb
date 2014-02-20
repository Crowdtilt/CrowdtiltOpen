class Tab < ActiveRecord::Base
  attr_accessible :campaign_id, :content, :sort_order, :title
  belongs_to :campaign
end
