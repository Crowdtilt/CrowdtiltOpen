class Settings < ActiveRecord::Base
  attr_accessible :site_name, :facebook_app_id, :google_id, :tweet_text, :initialized_flag,
                  :logo_image, :logo_image_delete, :copyright_text, :facebook_title,
                  :facebook_description, :facebook_image, :facebook_image_delete, :homepage_content,
                  :custom_css, :header_link_text, :header_link_url, :ct_sandbox_guest_id, :ct_production_guest_id,
                  :ct_sandbox_admin_id, :ct_production_admin_id, :reply_to_email, :custom_js, :default_campaign_id, :indexable, :phone_number

  attr_accessor :logo_image_delete, :facebook_image_delete

  validates :site_name, presence: true
  validates :reply_to_email, presence: true, email: true
  before_create :set_api_key

  before_validation { logo_image.clear if logo_image_delete == '1' }
  before_validation { facebook_image.clear if facebook_image_delete == '1' }

  belongs_to "default_campaign", :class_name => "Campaign"

  has_attached_file :logo_image,
                    styles: { thumb: "100x100#" }

  has_attached_file :facebook_image,
                    styles: { thumb: "100x100#" }

  def billing_statement_text
    ('CH ' + site_name.upcase)[0, 18]
  end

  def activate_payments(key, secret)
      Crowdtilt.configure api_key: key,
                                  api_secret: secret,
                                  mode: 'production'
      begin
        Crowdtilt.get('users')
      rescue => exception
        return false
      else
        self.ct_prod_api_key = key
        self.ct_prod_api_secret = secret
        begin
          Crowdtilt.production(self)
          production_admin = {
            firstname: 'Crowdhoster',
            lastname: (Rails.configuration.crowdhoster_app_name + '-admin'),
            email: (Rails.configuration.crowdhoster_app_name + '-admin@crowdhoster.com')
          }
          production_admin = Crowdtilt.post('/users', {user: production_admin})
        rescue => exception
          return false
        else
          self.ct_production_admin_id = production_admin['user']['id']
          self.save
        end
      end
  end

  def payments_activated?
    !self.ct_prod_api_key.blank? && !self.ct_prod_api_secret.blank? && !self.ct_production_admin_id.blank?
  end

  private

  def set_api_key
    self[:api_key] = SecureRandom.hex(10)
  end

end
