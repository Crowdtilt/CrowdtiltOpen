class AddAdditionalInfoField < ActiveRecord::Migration
  def change
    add_column :campaigns, :collect_additional_info, :boolean, null: false, default: false
    add_column :campaigns, :additional_info_label, :string
    add_column :payments, :additional_info, :text
  end
end
