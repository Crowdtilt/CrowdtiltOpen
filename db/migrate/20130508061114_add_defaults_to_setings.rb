class AddDefaultsToSetings < ActiveRecord::Migration
  def change
    change_column :settings, :site_name, :string, null: false, default: 'Selfstarter'
  end
end
