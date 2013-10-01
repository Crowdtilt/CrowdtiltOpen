class AddWantsAdminPaymentNotificationToUser < ActiveRecord::Migration
  def change
    add_column :users, :wants_admin_payment_notification, :boolean, :null => false, :default => true
  end
end
