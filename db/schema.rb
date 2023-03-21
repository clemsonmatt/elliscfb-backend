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

ActiveRecord::Schema[7.0].define(version: 2023_03_21_181646) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conferences", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_short", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.bigint "conference_id", null: false
    t.string "name", null: false
    t.string "name_short", null: false
    t.string "name_abbr", null: false
    t.string "slug", null: false
    t.string "mascot"
    t.string "city"
    t.string "state"
    t.string "school"
    t.string "stadium_name"
    t.string "primary_color"
    t.string "secondary_color"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conference_id"], name: "index_teams_on_conference_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.json "roles"
    t.boolean "email_subscription", default: false
    t.string "phone"
    t.boolean "text_subscription", default: false
    t.string "phone_carrier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "teams", "conferences"
end
