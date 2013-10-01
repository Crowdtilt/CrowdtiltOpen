class AddRewardSupport < ActiveRecord::Migration
  def change
    add_column :payments, :reward_id, :integer
    add_column :campaigns, :include_rewards, :boolean, null: false, default: false
    add_column :campaigns, :reward_reference, :string, null: false, default: 'reward'
  end
end
