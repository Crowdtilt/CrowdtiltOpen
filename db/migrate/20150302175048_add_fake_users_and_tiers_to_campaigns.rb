class AddFakeUsersAndTiersToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :fake_users, :integer, :default => 0

  	add_column :campaigns, :base_price, :decimal
  end
end
