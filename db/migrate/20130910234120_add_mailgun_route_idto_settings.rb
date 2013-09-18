class AddMailgunRouteIdtoSettings < ActiveRecord::Migration
  def change
    add_column :sites, :mailgun_route_id, :string
  end
end
