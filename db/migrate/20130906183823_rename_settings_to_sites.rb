class RenameSettingsToSites < ActiveRecord::Migration
  def change
    rename_table :settings, :sites
  end
end
