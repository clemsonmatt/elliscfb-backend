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

ActiveRecord::Schema[7.0].define(version: 2023_03_22_013548) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conferences", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_short", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.bigint "home_team_id", null: false
    t.bigint "away_team_id", null: false
    t.bigint "winning_team_id"
    t.date "date", null: false
    t.string "time"
    t.string "location"
    t.decimal "spread", precision: 3, scale: 1
    t.bigint "predicted_winning_team_id"
    t.boolean "conference_championship", default: false
    t.string "bowl_name"
    t.boolean "pickem", default: false
    t.boolean "canceled", default: false
    t.string "network"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["away_team_id"], name: "index_games_on_away_team_id"
    t.index ["home_team_id"], name: "index_games_on_home_team_id"
    t.index ["predicted_winning_team_id"], name: "index_games_on_predicted_winning_team_id"
    t.index ["winning_team_id"], name: "index_games_on_winning_team_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.integer "year", null: false
    t.boolean "active", default: false
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

  create_table "weeks", force: :cascade do |t|
    t.bigint "season_id", null: false
    t.integer "number", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_weeks_on_season_id"
  end

  add_foreign_key "games", "teams", column: "away_team_id"
  add_foreign_key "games", "teams", column: "home_team_id"
  add_foreign_key "games", "teams", column: "predicted_winning_team_id"
  add_foreign_key "games", "teams", column: "winning_team_id"
  add_foreign_key "teams", "conferences"
  add_foreign_key "weeks", "seasons"
end
