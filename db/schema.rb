# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_07_153704) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "articles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "url"
    t.hstore "opengraph_data"
    t.uuid "business_id", null: false
    t.datetime "crawled_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_id"], name: "index_articles_on_business_id"
  end

  create_table "businesses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.geography "latlon", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.text "notes"
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "national", default: false
    t.string "url"
    t.hstore "opengraph_data"
    t.decimal "lat"
    t.decimal "lon"
    t.string "category_id"
    t.boolean "online", default: false
    t.index ["category_id", "lat", "lon"], name: "businesses_category_lat_lon_idx"
    t.index ["category_id"], name: "index_businesses_on_category_id"
    t.index ["lat", "lon"], name: "index_businesses_on_lat_and_lon"
    t.index ["latlon"], name: "index_businesses_on_latlon", using: :gist
    t.index ["national"], name: "index_businesses_on_national"
    t.index ["online"], name: "index_businesses_on_online"
  end

  create_table "categories", id: :string, force: :cascade do |t|
    t.string "display_name"
    t.text "description"
    t.string "icon_class"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "business_id", null: false
    t.string "name"
    t.string "address"
    t.text "notes"
    t.geometry "latlon", limit: {:srid=>0, :type=>"st_point"}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "lat"
    t.decimal "lon"
    t.index ["business_id"], name: "index_locations_on_business_id"
    t.index ["lat", "lon"], name: "index_locations_on_lat_and_lon"
    t.index ["latlon"], name: "index_locations_on_latlon", using: :gist
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin"
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "articles", "businesses"
  add_foreign_key "businesses", "categories"
  add_foreign_key "locations", "businesses"
end
