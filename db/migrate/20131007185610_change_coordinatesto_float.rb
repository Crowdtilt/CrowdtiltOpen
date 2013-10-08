class ChangeCoordinatestoFloat < ActiveRecord::Migration
  def change
    change_column :bootcamps, :lat, :float
    change_column :bootcamps, :lon, :float
  end
end
