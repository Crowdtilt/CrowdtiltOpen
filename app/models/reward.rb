class Reward < ActiveRecord::Base
  attr_accessible :title, :description, :delivery_date, :number, :price, :campaign_id, :visible_flag

   validates :title, :description, :delivery_date, :price, presence: true

  belongs_to :campaign
  has_many :payments

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
