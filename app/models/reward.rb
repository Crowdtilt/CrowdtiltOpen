# == Schema Information
# Schema version: 20130909221117
#
# Table name: rewards
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  description   :text
#  delivery_date :string(255)
#  number        :integer
#  price         :float
#  campaign_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  visible_flag  :boolean          default(TRUE), not null
#  site_id       :integer          not null
#
# Indexes
#
#  index_rewards_on_site_id  (site_id)
#

class Reward < ActiveRecord::Base
  attr_accessible :title, :description, :delivery_date, :number, :price, :campaign_id, :visible_flag

   validates :title, :description, :delivery_date, :price, presence: true

  belongs_to :campaign
  has_many :payments

  default_scope { where(site_id: Site.current_id) }

  def sold_out?
    !self.unlimited? && number_of_payments >= self.number
  end

  def number_of_payments
    self.payments.count
  end

  def unlimited?
    self.number.nil? || self.number == 0
  end

  def visible?
    self.visible_flag
  end

end
