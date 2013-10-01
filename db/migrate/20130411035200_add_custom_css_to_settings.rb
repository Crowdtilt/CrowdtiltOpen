class AddCustomCssToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :custom_css, :text
  end
end
