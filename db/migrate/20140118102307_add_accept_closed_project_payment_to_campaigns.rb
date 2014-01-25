class AddAcceptClosedProjectPaymentToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :accept_closed_project_payment, :boolean
  end
end
