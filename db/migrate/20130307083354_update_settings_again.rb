class UpdateSettingsAgain < ActiveRecord::Migration
  def self.up 
    change_table :settings do |t|
      t.string  :copyright_text
      t.text    :confirmation_page_content
      t.text    :confirmation_email_content
      t.string  :facebook_title
      t.text    :facebook_description
      
      t.remove  :use_video_placeholder
      t.remove  :amazon_access_key
      t.remove  :amazon_secret_key
      t.remove  :price
      t.remove  :charge_limit
      t.remove  :contributor_verb
      t.remove  :checkout_header
      t.remove  :checkout_sidebar
    end
  end
  
  def self.down
    change_table :settings do |t|
      t.remove  :copyright_text
      t.remove  :confirmation_page_content
      t.remove  :confirmation_email_content
      t.remove  :facebook_title
      t.remove  :facebook_description
      
      t.boolean :use_video_placeholder
      t.string  :amazon_access_key
      t.string  :amazon_secret_key
      t.float   :price
      t.float   :charge_limit
      t.string  :contributor_verb
      t.string  :checkout_header
      t.text    :checkout_sidebar  
    end
  end
end
