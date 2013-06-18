class Faq < ActiveRecord::Base
  belongs_to :campaign
  attr_accessible :question, :answer, :sort_order, :campaign_id
end
