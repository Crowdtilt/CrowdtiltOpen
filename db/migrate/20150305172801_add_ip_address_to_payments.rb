class AddIpAddressToPayments < ActiveRecord::Migration
  def change
  	add_column :payments, :ip_addr, :text
  end
end
