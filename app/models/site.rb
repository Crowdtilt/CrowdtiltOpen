# == Schema Information
# Schema version: 20130910184139
#
# Table name: sites
#
#  id                          :integer          not null, primary key
#  site_name                   :string(255)      default("Crowdhoster"), not null
#  facebook_app_id             :string(255)
#  tweet_text                  :string(255)
#  google_id                   :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  initialized_flag            :boolean          default(FALSE), not null
#  logo_image_file_name        :string(255)
#  logo_image_content_type     :string(255)
#  logo_image_file_size        :integer
#  logo_image_updated_at       :datetime
#  copyright_text              :string(255)
#  facebook_title              :string(255)
#  facebook_description        :text
#  facebook_image_file_name    :string(255)
#  facebook_image_content_type :string(255)
#  facebook_image_file_size    :integer
#  facebook_image_updated_at   :datetime
#  homepage_content            :text
#  custom_css                  :text
#  ct_sandbox_guest_id         :string(255)
#  header_link_text            :string(255)
#  header_link_url             :string(255)
#  ct_sandbox_admin_id         :string(255)
#  ct_production_admin_id      :string(255)
#  ct_production_guest_id      :string(255)
#  api_key                     :string(255)
#  reply_to_email              :string(255)      default("team@crowdhoster.com"), not null
#  custom_js                   :text
#  subdomain                   :string(255)      not null
#
# Indexes
#
#  index_sites_on_subdomain  (subdomain) UNIQUE
#

class Site < ActiveRecord::Base
  resourcify # Apply roles to this model

  attr_accessible :site_name, :facebook_app_id, :google_id, :tweet_text, :initialized_flag,
                  :logo_image, :logo_image_delete, :copyright_text, :facebook_title,
                  :facebook_description, :facebook_image, :facebook_image_delete, :homepage_content,
                  :custom_css, :header_link_text, :header_link_url, :ct_sandbox_guest_id, 
                  :ct_production_guest_id, :ct_sandbox_admin_id, :ct_production_admin_id, 
                  :reply_to_email, :custom_js, :subdomain, :custom_domain

  attr_accessor :logo_image_delete, :facebook_image_delete, :admin_user

  validates :site_name, presence: true
  validates :reply_to_email, presence: true, email: true
  validates :subdomain, presence: true, uniqueness: true, subdomain: true
  validates :custom_domain, domain: true if Rails.env != 'development'
  validates :admin_user, presence: {on: :create} if Rails.configuration.multisite_enabled

  before_validation { logo_image.clear if logo_image_delete == '1' }
  before_validation { facebook_image.clear if facebook_image_delete == '1' }
  before_validation :set_subdomain, on: :create
  before_validation :sanitize_custom_domain

  before_save { subdomain.downcase! }

  before_create :set_api_key

  after_create :initialize_site

  has_attached_file :logo_image,
                    styles: { thumb: "100x100#" }

  has_attached_file :facebook_image,
                    styles: { thumb: "100x100#" }

  # Thread-safe setter/getter for subdomain scoping
  def self.current_id=(id)
    Thread.current[:site_id] = id
  end

  def self.current_id
    Thread.current[:site_id]
  end

  def to_log_info
    return "#{self.id} - #{self.site_name} (#{self.subdomain}/#{self.custom_domain})"
  end

  def billing_statement_text
    ('CH ' + site_name.upcase)[0, 18]
  end

  def initialize_site(admin_user=nil)
    # Return true if already initialized
    if self.initialized_flag
      return true
    end

    # Set admin_user_id for init.
    if admin_user.nil?
      if self.admin_user.nil? 
        raise ArgumentError, 'No admin user provided!'
      end
      admin_user = self.admin_user
    end

    # Add current user as admin on this site
    admin_user.add_role :admin, self

    # Set default reply_to_email to admin user email
    self.update_attribute :reply_to_email, admin_user.email

    Crowdtilt.sandbox
    sandbox_guest = {
      firstname: 'Crowdhoster',
      lastname: (Rails.configuration.crowdhoster_app_name + '-guest'),
      email: (Rails.configuration.crowdhoster_app_name + '-guest@crowdhoster.com')
    }
    sandbox_guest = Crowdtilt.post('/users', {user: sandbox_guest})

    sandbox_admin = {
      firstname: 'Crowdhoster',
      lastname: (Rails.configuration.crowdhoster_app_name + '-admin'),
      email: (Rails.configuration.crowdhoster_app_name + '-admin@crowdhoster.com')
    }
    sandbox_admin = Crowdtilt.post('/users', {user: sandbox_admin})

    Crowdtilt.production
    production_guest = {
      firstname: 'Crowdhoster',
      lastname: (Rails.configuration.crowdhoster_app_name + '-guest'),
      email: (Rails.configuration.crowdhoster_app_name + '-guest@crowdhoster.com')
    }
    production_guest = Crowdtilt.post('/users', {user: production_guest})

    production_admin = {
      firstname: 'Crowdhoster',
      lastname: (Rails.configuration.crowdhoster_app_name + '-admin'),
      email: (Rails.configuration.crowdhoster_app_name + '-admin@crowdhoster.com')
    }
    production_admin = Crowdtilt.post('/users', {user: production_admin})

    updates_hash = {
      initialized_flag: true,
      ct_sandbox_guest_id: sandbox_guest['user']['id'],
      ct_sandbox_admin_id: sandbox_admin['user']['id'],
      ct_production_guest_id: production_guest['user']['id'],
      ct_production_admin_id: production_admin['user']['id']
    }

    self.update_attributes!(updates_hash)

  end

  private

  def set_api_key
    self.api_key = SecureRandom.hex(10)
  end

  def set_subdomain
    self.subdomain[0] ||= self.site_name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') + "-#{SecureRandom.hex(6)}"
  end

  def sanitize_custom_domain
    if self.custom_domain && self.custom_domain[0]
      # Remove protocol from URL (http://, https://, etc...) and anything after the first slash
      self.custom_domain = self.custom_domain.sub(/^.*?\/\//, '').reverse.sub(/^.*\//, '').reverse
    else
      self.custom_domain = nil
    end
  end

end
