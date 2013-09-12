class AddCustomDomainToSites < ActiveRecord::Migration
  def change
    add_column :sites, :custom_domain, :string
    add_index :sites, :custom_domain, :unique => true
  end
end
