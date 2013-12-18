class AddClientTimestampToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :client_timestamp, :integer, :limit => 8
  end
end
