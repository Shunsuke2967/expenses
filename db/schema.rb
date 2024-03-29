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

ActiveRecord::Schema[7.0].define(version: 2022_08_20_231127) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "budgets", force: :cascade do |t|
    t.bigint "expense_id", null: false
    t.bigint "rent", default: 0, null: false
    t.bigint "cost_of_living", default: 0, null: false
    t.bigint "food_expenses", default: 0, null: false
    t.bigint "entertainment", default: 0, null: false
    t.bigint "other", default: 0, null: false
    t.bigint "car_cost", default: 0, null: false
    t.bigint "insurance", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_budgets_on_expense_id"
  end

  create_table "days", force: :cascade do |t|
    t.datetime "day_at", precision: nil
    t.integer "icon", null: false
    t.string "memo"
    t.boolean "spending"
    t.bigint "money", null: false
    t.bigint "expense_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_days_on_expense_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.datetime "date_at", precision: nil, null: false
    t.bigint "salary", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "salary_2"
    t.bigint "salary_3"
    t.bigint "salary_4"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.integer "icon", null: false
    t.string "memo"
    t.boolean "spending"
    t.bigint "money", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_templates_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "demo", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "budgets", "expenses"
  add_foreign_key "days", "expenses"
  add_foreign_key "expenses", "users"
  add_foreign_key "templates", "users"
end
