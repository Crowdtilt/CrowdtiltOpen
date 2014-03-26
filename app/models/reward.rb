class Reward < ActiveRecord::Base
  attr_accessible :title, :description, :delivery_date, :number, :price, :campaign_id, :visible_flag,
                  :image_url, :collect_shipping_flag, :include_claimed

   validates :title, :description, :delivery_date, :price, presence: true
   validates :image_url, :format => URI::regexp(%w(http https)), :allow_blank => true

  belongs_to :campaign
  has_many :payments

  def sold_out?
    !self.unlimited? && self.number_of_successful_payments >= self.number
  end

  def number_of_payments
    self.payments.count
  end

  def number_of_successful_payments
    self.payments.successful.count
  end

  def unlimited?
    self.number.nil? || self.number == 0
  end

  def visible?
    self.visible_flag
  end

end
