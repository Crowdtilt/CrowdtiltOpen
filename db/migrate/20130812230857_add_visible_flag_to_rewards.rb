class AddVisibleFlagToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :visible_flag, :boolean, null: false, default: true
  end
end
