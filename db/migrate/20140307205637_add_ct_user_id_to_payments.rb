class AddCtUserIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :ct_user_id, :string
  end
end
