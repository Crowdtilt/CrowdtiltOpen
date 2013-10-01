class AddQuantityToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :quantity, :integer
  end
end
