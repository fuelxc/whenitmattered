class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories, id: :string do |t|
      t.string :display_name
      t.text :description
      t.string :icon_class

      t.timestamps
    end
  end
end
