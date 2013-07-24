class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string  :ct_payment_id
      t.string  :status
      t.integer :amount
      t.integer :user_fee_amount
      t.integer :admin_fee_amount
      
      t.string  :fullname
      t.string  :email
      
      t.string :card_type
      t.string :card_last_four
      t.string :card_expiration_month
      t.string :card_expiration_year
      
      t.integer :campaign_id
      
      t.timestamps
    end
  end
end
