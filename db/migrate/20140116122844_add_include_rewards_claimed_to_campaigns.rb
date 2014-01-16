class AddIncludeRewardsClaimedToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :include_rewards_claimed, :boolean
  end
end
