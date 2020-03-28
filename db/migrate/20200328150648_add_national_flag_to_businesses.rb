class AddNationalFlagToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :national, :boolean, index: true
  end
end
