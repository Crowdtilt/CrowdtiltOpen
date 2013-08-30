class AddBillingPostalCodeToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :billing_postal_code, :string
  end
end
