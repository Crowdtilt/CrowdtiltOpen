class AddCtAdminIdToSettings < ActiveRecord::Migration
  def self.up 
    change_table :settings do |t|
      t.string   :ct_sandbox_admin_id
      t.string   :ct_production_admin_id
      t.rename   :ct_guest_user_id, :ct_sandbox_guest_id
      t.string   :ct_production_guest_id
    end
    change_table :users do |t|
      t.remove   :has_default_bank
      t.remove   :ct_user_id
    end
  end
  
  def self.down
    change_table :settings do |t|
      t.remove   :ct_sandbox_admin_id
      t.remove   :ct_production_admin_id
      t.rename   :ct_sandbox_guest_id, :ct_guest_user_id
      t.remove   :ct_production_guest_id
    end
    change_table :users do |t|
      t.boolean   :has_default_bank
      t.string    :ct_user_id
    end
  end
end
