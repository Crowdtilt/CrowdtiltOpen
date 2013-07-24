class AddShippingToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :address_one, :string
    add_column :payments, :address_two, :string
    add_column :payments, :city, :string
    add_column :payments, :state, :string
    add_column :payments, :postal_code, :string
    add_column :payments, :country, :string
    
    add_column :campaigns, :collect_shipping, :boolean, null: false, default: false  
  end
end
