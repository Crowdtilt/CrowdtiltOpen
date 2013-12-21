class AddShippingToggleToReward < ActiveRecord::Migration
  def change
    add_column :rewards, :collect_shipping_flag, :boolean, default: true
  end
end
