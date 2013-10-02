class UpdateSettings < ActiveRecord::Migration
  def self.up 
    change_table :settings do |t|
      t.string :contributor_verb
      t.string :secondary_call_to_action_button  
      t.string :checkout_header
      
      t.text   :checkout_sidebar      
      t.text   :primary_call_to_action_description
      t.text   :secondary_call_to_action_description
      t.text   :main_content
      
      t.rename :product_name, :project_name
      t.rename :value_proposition, :tagline
      t.rename :primary_stat, :contributor_reference
      t.rename :call_to_action, :primary_call_to_action_button
      
      t.remove :product_description
      t.remove :payment_description
      t.remove :product_image_path
      t.remove :primary_stat_verb
      t.remove :middle_reserve_text
      t.remove :ships
      t.remove :dont_give_them_a_reason_to_say_no
      t.remove :price_human
    end
  end
  
  def self.down
    change_table :settings do |t|
      t.remove :contributor_verb
      t.remove :secondary_call_to_action_button  
      t.remove :checkout_header
      
      t.remove :checkout_sidebar      
      t.remove :primary_call_to_action_description
      t.remove :secondary_call_to_action_description
      t.remove :main_content
      
      t.rename :project_name, :product_name
      t.rename :tagline, :value_proposition
      t.rename :contributor_reference, :primary_stat
      t.rename :primary_call_to_action_button, :call_to_action

      t.string :product_description      
      t.string :payment_description
      t.string :product_image_path
      t.string :primary_stat_verb
      t.string :middle_reserve_text
      t.string :ships
      t.string :dont_give_them_a_reason_to_say_no
      t.string :price_human    
    end
  end
end
