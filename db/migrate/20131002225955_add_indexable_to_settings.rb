class AddIndexableToSettings < ActiveRecord::Migration
  def up
    add_column :settings, :indexable, :boolean, :default => true
  end

  def down
    remove_column :settings, :indexable
  end
end
