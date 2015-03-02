class CreateCampaignTiers < ActiveRecord::Migration
  def change
    create_table :campaign_tiers do |t|
      t.integer :campaign_id
      t.decimal :price_at_tier
      t.integer :min_users

      t.timestamps
    end
  end
end
