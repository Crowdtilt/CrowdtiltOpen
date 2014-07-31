class ChangeDefaultSiteName < ActiveRecord::Migration
  def change
    change_column :settings, :site_name, :string, :default => 'Tilt Open', :null => false
  end
end
