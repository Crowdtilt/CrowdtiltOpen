class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string     :name
      t.float      :goal
      t.datetime   :expiration_date
      t.string     :ct_campaign_id 
      
      t.string     :media_type, :null => false, :default => 'video'
      t.attachment :main_image
      t.string     :video_embed_id
      t.attachment :video_placeholder
      t.string     :contributor_reference, :default => 'backer'      
      t.string     :progress_text, :default => 'funded'
            
      t.string     :primary_call_to_action_button, :default => 'Contribute'
      t.text       :primary_call_to_action_description
      t.string     :secondary_call_to_action_button, :default => 'Contribute'
      t.text       :secondary_call_to_action_description
      t.text       :main_content     
      
      t.text       :checkout_sidebar_content     
      t.text       :confirmation_page_content      
      t.text       :confirmation_email_content          
      
      t.string     :payment_type, :null => false, :default => 'any'
      t.float      :min_payment_amount, :null => false, :default => 1.0
      t.float      :fixed_payment_amount, :null => false, :default => 1.0
      t.boolean    :apply_processing_fee, :null => false, :default => false
      t.boolean    :collect_shipping_address, :null => false, :default => false          

      t.string     :tweet_text
      t.string     :facebook_title
      t.text       :facebook_description
      t.attachment :facebook_image
      
      t.string     :slug, :unique => true

      t.timestamps
    end    
    add_index :campaigns, :slug, :unique => true
  end   
end
