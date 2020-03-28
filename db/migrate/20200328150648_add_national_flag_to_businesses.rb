class AddNationalFlagToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :national, :boolean, default: false
    add_index :businesses, :national
  end
end
