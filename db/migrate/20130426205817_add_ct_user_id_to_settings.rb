class AddCtUserIdToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :ct_guest_user_id, :string
  end
end
