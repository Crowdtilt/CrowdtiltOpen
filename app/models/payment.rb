class Payment < ActiveRecord::Base
  attr_accessible :ct_payment_id, :status, :amount, :user_fee_amount, :admin_fee_amount, :fullname, :email,
                  :card_type, :card_last_four, :card_expiration_month, :card_expiration_year, :billing_postal_code,
                  :address_one, :address_two, :city, :state, :postal_code, :country, :quantity,
                  :additional_info, :client_timestamp,
                  :ct_charge_request_id, :ct_charge_request_error_id,
                  :ct_tokenize_request_id, :ct_tokenize_request_error_id,
                  :ct_user_id

  validates :fullname, :quantity, presence: true
  validates :email, presence: true, email: true

  belongs_to :campaign
  belongs_to :reward

  scope :successful, where(status: %w(authorized charged released rejected offline))
  scope :completed, where(status: %w(authorized charged released rejected refunded offline))

  def self.to_csv(options={})
    #db_columns = %w{fullname email quantity amount user_fee_amount created_at status ct_payment_id}
    csv_columns = ['Name', 'Email', 'Quantity', 'Amount', 'User Fee', 'Date', 'Reward',
                   'Card Type', 'Card Last Four', 'Card Expiration Month', 'Card Expiration Year', 'Billing Postal Code',
                   'Address One', 'Address Two', 'City', 'State', 'Postal Code', 'Country',
                   'Additional Info','Status', 'ID']

    CSV.generate(options) do |csv|
      csv << csv_columns
      all.each do |payment|
        reward = payment.reward ? payment.reward.title : ''
        csv << [payment.fullname,
                payment.email,
                payment.quantity,
                display_dollars(payment.amount),
                display_dollars(payment.user_fee_amount),
                display_date(payment.created_at),
                reward,
                payment.card_type,
                payment.card_last_four,
                payment.card_expiration_month,
                payment.card_expiration_year,
                payment.billing_postal_code,
                payment.address_one,
                payment.address_two,
                payment.city,
                payment.state,
                payment.postal_code,
                payment.country,
                payment.additional_info,
                payment.status,
                payment.ct_payment_id]
        end
      end
  end

  def update_api_data(payment)
    self.ct_payment_id = payment['id']
    self.status = payment['status']
    self.amount = payment['amount']
    self.user_fee_amount = payment['user_fee_amount']
    self.admin_fee_amount = payment['admin_fee_amount']
    self.card_type = payment['card']['card_type']
    self.card_last_four = payment['card']['last_four']
    self.card_expiration_month = payment['card']['expiration_month']
    self.card_expiration_year = payment['card']['expiration_year']
  end

  def refund!
    self.campaign.production_flag ? Crowdtilt.production(Settings.first) : Crowdtilt.sandbox
    Crowdtilt.post("/campaigns/#{self.campaign.ct_campaign_id}/payments/#{self.ct_payment_id}/refund")
    self.update_attribute(:status, "refunded")
  end

  def self.display_dollars(amount)
    "$#{(amount.to_f/100.0).round(2)}"
  end

  def self.display_date(date)
    date.strftime("%m/%d/%Y")
  end

end
