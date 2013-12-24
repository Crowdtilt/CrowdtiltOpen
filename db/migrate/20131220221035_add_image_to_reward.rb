class AddImageToReward < ActiveRecord::Migration
  def change
    add_column :rewards, :image_url, :string
  end
end
