class AddSoldOutFlagToCampaign < ActiveRecord::Migration
  def change
  	add_column :campaigns, :sold_out, :boolean, :default => false
  end
end
