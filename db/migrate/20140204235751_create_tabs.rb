class CreateTabs < ActiveRecord::Migration
  def change
    create_table :tabs do |t|
      t.string :title
      t.text :content
      t.integer :sort_order
      t.integer :campaign_id

      t.timestamps
    end

    add_column :campaigns, :use_tabs, :boolean
  end
end
