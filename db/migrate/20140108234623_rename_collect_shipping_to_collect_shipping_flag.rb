class RenameCollectShippingToCollectShippingFlag < ActiveRecord::Migration
  def change
    rename_column :campaigns, :collect_shipping, :collect_shipping_flag
  end
end
