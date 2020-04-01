class AddLatLonAsSeperateColumnsToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :lat, :decimal
    add_column :locations, :lon, :decimal
    add_index :locations, [:lat, :lon]
  end
end
