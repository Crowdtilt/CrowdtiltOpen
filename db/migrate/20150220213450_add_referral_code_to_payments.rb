class AddReferralCodeToPayments < ActiveRecord::Migration
  def change
  	add_column :payments, :referred_by, :text
  end
end
