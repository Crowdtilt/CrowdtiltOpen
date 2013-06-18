class AddApiKeyToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :api_key, :string
  end
end
