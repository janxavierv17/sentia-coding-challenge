# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_11_083215) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "affiliations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_affiliations_on_name", unique: true
  end

  create_table "affiliations_people", id: false, force: :cascade do |t|
    t.bigint "affiliation_id", null: false
    t.bigint "person_id", null: false
    t.index ["affiliation_id"], name: "index_affiliations_people_on_affiliation_id"
    t.index ["person_id", "affiliation_id"], name: "index_affiliations_people_on_person_id_and_affiliation_id", unique: true
    t.index ["person_id"], name: "index_affiliations_people_on_person_id"
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_locations_on_name", unique: true
  end

  create_table "locations_people", id: false, force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "person_id", null: false
    t.index ["location_id"], name: "index_locations_people_on_location_id"
    t.index ["person_id", "location_id"], name: "index_locations_people_on_person_id_and_location_id", unique: true
    t.index ["person_id"], name: "index_locations_people_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "first_name", null: false
    t.string "last_name"
    t.datetime "updated_at", null: false
    t.string "vehicle"
    t.string "weapon"
  end

  add_foreign_key "affiliations_people", "affiliations"
  add_foreign_key "affiliations_people", "people"
  add_foreign_key "locations_people", "locations"
  add_foreign_key "locations_people", "people"
end
