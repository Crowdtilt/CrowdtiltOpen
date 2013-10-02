class AddCtUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ct_user_id, :string
  end
end
