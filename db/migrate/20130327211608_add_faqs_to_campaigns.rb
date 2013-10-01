class AddFaqsToCampaigns < ActiveRecord::Migration
  def change
    add_column :faqs, :campaign_id, :integer
  end
end
