class AddHomepageContentToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :homepage_content, :text  
  end
end
