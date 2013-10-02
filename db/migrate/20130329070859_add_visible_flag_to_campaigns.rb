class AddVisibleFlagToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :archive_flag, :boolean, null: false, default: false
  end
end
