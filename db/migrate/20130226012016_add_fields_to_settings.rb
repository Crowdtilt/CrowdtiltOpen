class AddFieldsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :media_type, :string, :null => false, :default => 'video'
    add_column :settings, :payment_type, :string, :null => false, :default => 'any'
    add_column :settings, :min_payment_amount, :float, :null => false, :default => 1.0
    add_column :settings, :fix_payment_amount, :float, :null => false, :default => 1.0
    add_column :settings, :user_fee_amount, :float, :null => false, :default => 0.0
    add_column :settings, :checkout_content, :text
  end
end
