class ChangeDefaultSiteName < ActiveRecord::Migration
  def change
    change_column :settings, :site_name, :string, :default => 'Crowdhoster', :null => false
  end
end
