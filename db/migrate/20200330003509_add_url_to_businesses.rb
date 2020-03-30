class AddUrlToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :url, :string
  end
end
