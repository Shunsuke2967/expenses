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

ActiveRecord::Schema.define(version: 2022_01_20_102743) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "budgets", force: :cascade do |t|
    t.bigint "month_id", null: false
    t.bigint "rent", null: false
    t.bigint "cost_of_living", null: false
    t.bigint "food_expenses", null: false
    t.bigint "entertainment", null: false
    t.bigint "others", null: false
    t.bigint "car_cost", null: false
    t.bigint "insurance", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["month_id"], name: "index_budgets_on_month_id"
  end

  create_table "days", force: :cascade do |t|
    t.datetime "day_at"
    t.string "icon"
    t.string "memo"
    t.boolean "income_and_outgo"
    t.bigint "money"
    t.bigint "month_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["month_id"], name: "index_days_on_month_id"
  end

  create_table "months", force: :cascade do |t|
    t.datetime "month_at", null: false
    t.bigint "income", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_months_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "icon", null: false
    t.string "memo"
    t.boolean "income_and_outgo"
    t.bigint "money", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_templates_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "budgets", "months"
  add_foreign_key "days", "months"
  add_foreign_key "months", "users"
  add_foreign_key "templates", "users"
end
