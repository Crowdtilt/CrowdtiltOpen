class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.string  :title
      t.text    :description
      t.string  :delivery_date
      t.integer :number
      t.float   :price
      t.integer :campaign_id
      t.timestamps
    end
  end
end