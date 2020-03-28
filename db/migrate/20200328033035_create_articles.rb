class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles, id: :uuid do |t|
      t.string :url
      t.hstore :opengraph_data
      t.references :business, null: false, foreign_key: true, type: :uuid
      t.datetime :crawled_at

      t.timestamps
    end
  end
end
