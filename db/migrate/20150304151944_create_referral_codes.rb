class CreateReferralCodes < ActiveRecord::Migration
  def change
    create_table :referral_codes do |t|
      t.text :email
      t.text :code
      t.text :comment

      t.timestamps
    end
  end
end
