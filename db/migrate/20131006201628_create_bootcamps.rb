class CreateBootcamps < ActiveRecord::Migration
  def change
    create_table :bootcamps do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :st_pr
      t.string :country
      t.string :contact_email
      t.string :website_url
      t.integer :campaign_id
      t.integer :lat
      t.integer :lon
      t.integer :twitter_handle
      t.text :description
      t.timestamps
    end
  end
end
