class RemoveOgFromBusinesses < ActiveRecord::Migration[6.0]
  def change
    remove_column :businesses, :opengraph_data
  end
end
