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

ActiveRecord::Schema[7.0].define(version: 2024_03_31_002338) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.bigint "activity_type_id"
    t.string "title"
    t.text "description"
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.integer "passcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.string "location"
    t.datetime "passcode_valid_at", precision: nil
    t.datetime "passcode_valid_end", precision: nil
    t.integer "points"
    t.index ["activity_type_id"], name: "index_activities_on_activity_type_id"
  end

  create_table "activity_participations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "activity_id", null: false
    t.boolean "attended"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.index ["activity_id"], name: "index_activity_participations_on_activity_id"
    t.index ["user_id"], name: "index_activity_participations_on_user_id"
  end

  create_table "activity_types", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "article_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "article_modules", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", default: 0
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.bigint "article_category_id"
    t.bigint "article_module_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_category_id"], name: "index_articles_on_article_category_id"
    t.index ["article_module_id"], name: "index_articles_on_article_module_id"
  end

  create_table "points", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "amount"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_points_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.boolean "officer", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_picture"
    t.string "timezone", default: "Central Time (US & Canada)"
  end

  add_foreign_key "activities", "activity_types"
  add_foreign_key "activity_participations", "activities"
  add_foreign_key "activity_participations", "users"
  add_foreign_key "articles", "article_categories"
  add_foreign_key "articles", "article_modules"
  add_foreign_key "points", "users"
end
