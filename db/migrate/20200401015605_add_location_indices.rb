class AddLocationIndices < ActiveRecord::Migration[6.0]
  def change
    add_index :locations, :latlon, using: :gist
  end
end
