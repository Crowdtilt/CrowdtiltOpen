class AddHeaderLinkToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :header_link_text, :string
    add_column :settings, :header_link_url, :string
  end
end
