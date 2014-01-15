class CampaignSerializer < ActiveModel::Serializer
  has_many :rewards

  attributes :id, :name, :goal_type, :goal_dollars, :goal_orders,  :expiration_date, :ct_campaign_id, :media_type,
             :main_image, :main_image_delete, :video_embed_id, :video_placeholder, :video_placeholder_delete,
             :contributor_reference, :progress_text, :primary_call_to_action_button, :primary_call_to_action_description,
             :secondary_call_to_action_button, :secondary_call_to_action_description, :main_content,
             :checkout_sidebar_content, :confirmation_page_content, :confirmation_email_content,
             :tweet_text, :facebook_title, :facebook_description,  :facebook_image, :facebook_image_delete,
             :payment_type, :fixed_payment_amount, :min_payment_amount, :apply_processing_fee,
             :stats_number_of_contributions, :stats_raised_amount, :stats_tilt_percent,
             :stats_unique_contributors, :published_flag, :collect_shipping_flag, :production_flag,
             :include_rewards, :reward_reference, :collect_additional_info, :additional_info_label, :url, :payments_uri,
             :include_comments, :comments_shortname

  def url
    campaign_home_url(object)
  end

  def payments_uri
    api_campaign_payments_path(campaign_id: object.id)
  end
end
