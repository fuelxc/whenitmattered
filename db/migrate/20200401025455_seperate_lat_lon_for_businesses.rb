class SeperateLatLonForBusinesses < ActiveRecord::Migration[6.0]
  def change
    rename_column :businesses, :lonlat, :latlon
    add_column :businesses, :lat, :decimal
    add_column :businesses, :lon, :decimal
    add_index :businesses, [:lat, :lon]
  end
end
