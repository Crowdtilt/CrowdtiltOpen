class AddProductionFlagToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :production_flag, :boolean, null: false, default: false
  end
end
