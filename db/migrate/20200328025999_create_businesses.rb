class CreateBusinesses < ActiveRecord::Migration[6.0]
  def change
    create_table :businesses, id: :uuid do |t|
      t.string :name
      t.st_point :lonlat, geographic: true
      t.hstore :opengraph_data
      t.text :notes
      t.string :address

      t.timestamps
    end
    add_index :businesses, :lonlat, using: :gist
  end
end
