class Site < ActiveRecord::Base
  attr_accessible :site_name, :facebook_app_id, :google_id, :tweet_text, :initialized_flag,
                  :logo_image, :logo_image_delete, :copyright_text, :facebook_title,
                  :facebook_description, :facebook_image, :facebook_image_delete, :homepage_content,
                  :custom_css, :header_link_text, :header_link_url, :ct_sandbox_guest_id, :ct_production_guest_id,
                  :ct_sandbox_admin_id, :ct_production_admin_id, :reply_to_email, :custom_js

  attr_accessor :logo_image_delete, :facebook_image_delete

  validates :site_name, presence: true
  validates :reply_to_email, presence: true, email: true
  before_create :set_api_key

  before_validation { logo_image.clear if logo_image_delete == '1' }
  before_validation { facebook_image.clear if facebook_image_delete == '1' }

  has_attached_file :logo_image,
                    styles: { thumb: "100x100#" }

  has_attached_file :facebook_image,
                    styles: { thumb: "100x100#" }

  def billing_statement_text
    ('CH ' + site_name.upcase)[0, 18]
  end

  private

  def set_api_key
    self[:api_key] = SecureRandom.hex(10)
  end
end
