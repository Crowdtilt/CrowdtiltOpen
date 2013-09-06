# == Schema Information
# Schema version: 20130830004146
#
# Table name: campaigns
#
#  id                                   :integer          not null, primary key
#  name                                 :string(255)
#  expiration_date                      :datetime
#  ct_campaign_id                       :string(255)
#  media_type                           :string(255)      default("video"), not null
#  main_image_file_name                 :string(255)
#  main_image_content_type              :string(255)
#  main_image_file_size                 :integer
#  main_image_updated_at                :datetime
#  video_embed_id                       :string(255)
#  video_placeholder_file_name          :string(255)
#  video_placeholder_content_type       :string(255)
#  video_placeholder_file_size          :integer
#  video_placeholder_updated_at         :datetime
#  contributor_reference                :string(255)      default("backer")
#  progress_text                        :string(255)      default("funded")
#  primary_call_to_action_button        :string(255)      default("Contribute")
#  primary_call_to_action_description   :text
#  secondary_call_to_action_button      :string(255)      default("Contribute")
#  secondary_call_to_action_description :text
#  main_content                         :text
#  checkout_sidebar_content             :text
#  confirmation_page_content            :text
#  confirmation_email_content           :text
#  payment_type                         :string(255)      default("any"), not null
#  min_payment_amount                   :float            default(1.0), not null
#  fixed_payment_amount                 :float            default(1.0), not null
#  apply_processing_fee                 :boolean          default(FALSE), not null
#  tweet_text                           :string(255)
#  facebook_title                       :string(255)
#  facebook_description                 :text
#  facebook_image_file_name             :string(255)
#  facebook_image_content_type          :string(255)
#  facebook_image_file_size             :integer
#  facebook_image_updated_at            :datetime
#  slug                                 :string(255)
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  stats_number_of_contributions        :integer
#  stats_raised_amount                  :float
#  stats_tilt_percent                   :float
#  stats_unique_contributors            :integer
#  is_expired                           :boolean
#  is_tilted                            :boolean
#  is_paid                              :boolean
#  published_flag                       :boolean          default(FALSE), not null
#  collect_shipping                     :boolean          default(FALSE), not null
#  goal_type                            :string(255)      default("dollars"), not null
#  goal_dollars                         :float            default(1.0), not null
#  goal_orders                          :integer          default(1), not null
#  production_flag                      :boolean          default(FALSE), not null
#  include_rewards                      :boolean          default(FALSE), not null
#  reward_reference                     :string(255)      default("reward"), not null
#  collect_additional_info              :boolean          default(FALSE), not null
#  additional_info_label                :string(255)
#  include_comments                     :boolean          default(FALSE), not null
#  comments_shortname                   :string(255)
#
# Indexes
#
#  index_campaigns_on_slug  (slug) UNIQUE
#

class Campaign < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :faqs, dependent: :destroy
  has_many :payments
  has_many :rewards

  attr_accessible :name, :goal_type, :goal_dollars, :goal_orders,  :expiration_date, :ct_campaign_id, :media_type,
                  :main_image, :main_image_delete, :video_embed_id, :video_placeholder, :video_placeholder_delete,
                  :contributor_reference, :progress_text, :primary_call_to_action_button, :primary_call_to_action_description,
                  :secondary_call_to_action_button, :secondary_call_to_action_description, :main_content,
                  :checkout_sidebar_content, :confirmation_page_content, :confirmation_email_content,
                  :tweet_text, :facebook_title, :facebook_description,  :facebook_image, :facebook_image_delete,
                  :payment_type, :fixed_payment_amount, :min_payment_amount, :apply_processing_fee,
                  :stats_number_of_contributions, :stats_raised_amount, :stats_tilt_percent,
                  :stats_unique_contributors, :published_flag, :collect_shipping, :production_flag,
                  :include_rewards, :reward_reference, :collect_additional_info, :additional_info_label,
                  :include_comments, :comments_shortname

  attr_accessor :main_image_delete, :video_placeholder_delete, :facebook_image_delete

  validates :name, :expiration_date, presence: true
  validates :min_payment_amount, numericality: { greater_than_or_equal_to: 1.0 }
  validates :fixed_payment_amount, numericality: { greater_than_or_equal_to: 1.0 }
  validate :expiration_date_cannot_be_in_the_past

  before_validation { main_image.clear if main_image_delete == '1' }
  before_validation { video_placeholder.clear if video_placeholder_delete == '1' }
  before_validation { facebook_image.clear if facebook_image_delete == '1' }

  has_attached_file :main_image,
                    styles: { main: "512x385!", medium: "640x360!", small: "190x143!", thumb: "100x100#" }

  has_attached_file :video_placeholder,
                    styles: { main: "512x385!", medium: "640x360!", thumb: "100x100#" }  #The hash indicates cropping, use ! for forced scaling

  has_attached_file :facebook_image,
                    styles: { thumb: "100x100#" }

  before_save :set_min_amount

  def update_api_data(campaign)
    self.ct_campaign_id = campaign['id']
    self.stats_number_of_contributions = campaign['stats']['number_of_contributions']
    self.stats_raised_amount = campaign['stats']['raised_amount']/100.0
    self.stats_tilt_percent = campaign['stats']['tilt_percent']
    self.stats_unique_contributors = campaign['stats']['unique_contributors']
    self.is_tilted = campaign['is_tilted'].to_i == 0 ? false : true
    self.is_expired = campaign['is_expired'].to_i == 0 ? false : true
    self.is_paid = campaign['is_paid'].to_i == 0 ? false : true
  end

  def set_goal
    if self.goal_type == 'orders'
      self.goal_dollars = ((self.fixed_payment_amount * self.goal_orders)*100).round/100.0
    end
  end

  def expired?
    self.expiration_date < Time.current
  end

  def orders
    (self.stats_raised_amount / self.fixed_payment_amount).to_i
  end

  def rewards?
    (self.payment_type != 'fixed' && self.rewards.length > 0)
  end

  def raised_amount
    payments.where("payments.status!='refunded'").sum(:amount)/100.0
  end

  def number_of_contributions
    payments.where("payments.status!='refunded'").count
  end

  def tilt_percent
    (raised_amount / goal_dollars) * 100.0
  end

  private

  def set_min_amount
    if self.payment_type == "any"
      self.min_payment_amount = 1.0
    end
  end

  def expiration_date_cannot_be_in_the_past
    if self.expiration_date_changed? && !self.expiration_date.blank? && self.expiration_date < Time.current
      errors.add(:expiration_date, "can't be in the past")
    end
  end

end
