class RemoveExtraShippingFlag < ActiveRecord::Migration
  def up
    remove_column :campaigns, :collect_shipping_address
  end

  def down
    add_column :campaigns, :collect_shipping_address, :boolean, :null => false, :default => false
  end
end
