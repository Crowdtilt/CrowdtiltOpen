class AddCustomJsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :custom_js, :text
  end
end
