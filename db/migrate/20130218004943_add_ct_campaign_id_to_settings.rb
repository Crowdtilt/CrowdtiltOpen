class AddCtCampaignIdToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :ct_campaign_id, :string
  end
end
