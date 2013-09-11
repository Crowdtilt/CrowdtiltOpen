class AddMailgunRouteIdtoSettings < ActiveRecord::Migration
  def change
    add_column :settings, :mailgun_route_id, :string
  end
end
