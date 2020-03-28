class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations, id: :uuid do |t|
      t.references :business, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.string :address
      t.text :notes
      t.st_point :latlon

      t.timestamps
    end
  end
end
