class AddCrowdtiltProdKeysToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :ct_prod_api_key, :string
    add_column :settings, :ct_prod_api_secret, :string
  end
end
