class AddDefaultCampaignToSettings < ActiveRecord::Migration
  def up
    add_column :settings, :default_campaign_id, :integer
  end

  def down
    remove_column :settings, :default_campaign_id
  end
end
