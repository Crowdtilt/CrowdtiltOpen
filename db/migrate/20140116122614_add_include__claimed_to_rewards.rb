class AddIncludeClaimedToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :include_claimed, :boolean
  end
end
