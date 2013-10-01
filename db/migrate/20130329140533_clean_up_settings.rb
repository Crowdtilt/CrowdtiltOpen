class CleanUpSettings < ActiveRecord::Migration
  def self.up 
    change_table :settings do |t|
      t.rename :project_name, :site_name
  
      t.remove   :project_goal
      t.remove   :tagline
      t.remove   :video_embed_url
      t.remove   :use_payment_options
      t.remove   :contributor_reference
      t.remove   :expiration_date
      t.remove   :progress_text
      t.remove   :primary_call_to_action_button
      t.remove   :video_placeholder_file_name
      t.remove   :video_placeholder_content_type
      t.remove   :video_placeholder_file_size
      t.remove   :video_placeholder_updated_at
      t.remove   :secondary_call_to_action_button
      t.remove   :primary_call_to_action_description
      t.remove   :secondary_call_to_action_description
      t.remove   :main_content
      t.remove   :ct_campaign_id
      t.remove   :media_type
      t.remove   :payment_type
      t.remove   :min_payment_amount
      t.remove   :fix_payment_amount
      t.remove   :user_fee_amount
      t.remove   :checkout_content
      t.remove   :project_image_file_name
      t.remove   :project_image_content_type
      t.remove   :project_image_file_size
      t.remove   :project_image_updated_at
      t.remove   :confirmation_page_content
      t.remove   :confirmation_email_content
    end
  end
  
  def self.down
    change_table :settings do |t|
      t.rename   :site_name, :project_name
      
      t.float    :project_goal
      t.string   :tagline
      t.string   :video_embed_url
      t.boolean  :use_payment_options
      t.string   :contributor_reference
      t.datetime :expiration_date
      t.string   :progress_text
      t.string   :primary_call_to_action_button
      t.string   :video_placeholder_file_name
      t.string   :video_placeholder_content_type
      t.integer  :video_placeholder_file_size
      t.datetime :video_placeholder_updated_at
      t.string   :secondary_call_to_action_button
      t.text     :primary_call_to_action_description
      t.text     :secondary_call_to_action_description
      t.text     :main_content
      t.string   :ct_campaign_id
      t.string   :media_type,                           :default => "video", :null => false
      t.string   :payment_type,                         :default => "any",   :null => false
      t.float    :min_payment_amount,                   :default => 1.0,     :null => false
      t.float    :fix_payment_amount,                   :default => 1.0,     :null => false
      t.float    :user_fee_amount,                      :default => 0.0,     :null => false
      t.text     :checkout_content
      t.string   :project_image_file_name
      t.string   :project_image_content_type
      t.integer  :project_image_file_size
      t.datetime :project_image_updated_at
      t.text     :confirmation_page_content
      t.text     :confirmation_email_content
    end
  end
end
