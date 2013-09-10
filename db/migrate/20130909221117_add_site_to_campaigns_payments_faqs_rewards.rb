class AddSiteToCampaignsPaymentsFaqsRewards < ActiveRecord::Migration
  def change
    # Site_id should be non null but we add the constraint
    # later to deal with existing data in the table
    add_column :campaigns, :site_id, :integer
    add_column :payments, :site_id, :integer
    add_column :faqs, :site_id, :integer
    add_column :rewards, :site_id, :integer

    # Populate existing rows
    say_with_time "Scoping campaigns, payments, faqs, and rewards to sites..." do 
      [Campaign, Payment, Faq, Reward].each do |model|
        model.reset_column_information

        model.update_all(:site_id => 1)
      end
    end

    # Add non null constraint to site_id column
    change_column :campaigns, :site_id, :integer, :null => false
    change_column :payments, :site_id, :integer, :null => false
    change_column :faqs, :site_id, :integer, :null => false
    change_column :rewards, :site_id, :integer, :null => false

    add_index :campaigns, :site_id
    add_index :payments, :site_id
    add_index :faqs, :site_id
    add_index :rewards, :site_id
  end
end
