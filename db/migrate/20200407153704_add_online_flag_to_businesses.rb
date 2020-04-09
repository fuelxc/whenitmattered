class AddOnlineFlagToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :online, :boolean, default: false
    add_index :businesses, :online
  end
end
