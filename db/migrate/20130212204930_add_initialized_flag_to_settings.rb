class AddInitializedFlagToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :initialized_flag, :boolean, :null => false, :default => false
  end
end
