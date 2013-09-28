class AddHasDefaultBankToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_default_bank, :boolean, :null => false, :default => false
  end
end
