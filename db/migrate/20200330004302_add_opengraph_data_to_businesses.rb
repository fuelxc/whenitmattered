class AddOpengraphDataToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :opengraph_data, :hstore
  end
end
