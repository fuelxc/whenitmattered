class AddCategoryToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_reference :businesses, :category, null: true, foreign_key: true, type: :string
    add_index :businesses, [:category_id, :lat, :lon], name: 'businesses_category_lat_lon_idx'
  end
end
