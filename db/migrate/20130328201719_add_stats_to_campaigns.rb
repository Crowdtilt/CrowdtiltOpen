class AddStatsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :stats_number_of_contributions, :integer
    add_column :campaigns, :stats_raised_amount, :integer
    add_column :campaigns, :stats_tilt_percent, :float
    add_column :campaigns, :stats_unique_contributors, :integer
    add_column :campaigns, :is_expired, :boolean
    add_column :campaigns, :is_tilted, :boolean
    add_column :campaigns, :is_paid, :boolean
  end
end
