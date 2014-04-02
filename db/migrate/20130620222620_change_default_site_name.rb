class ChangeDefaultSiteName < ActiveRecord::Migration
  def change
    change_column :settings, :site_name, :string, :default => 'Crowdtilt Open', :null => false
  end
end
