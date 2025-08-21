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

ActiveRecord::Schema[7.1].define(version: 2025_08_21_121450) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "purchase_items", force: :cascade do |t|
    t.integer "quantity", default: 1, null: false
    t.decimal "discounted_price", precision: 10, scale: 2
    t.decimal "amount_without_discount", precision: 10, scale: 2
    t.bigint "purchase_id"
    t.bigint "shop_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purchase_id"], name: "index_purchase_items_on_purchase_id"
    t.index ["shop_item_id"], name: "index_purchase_items_on_shop_item_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.datetime "purchased_at"
    t.string "status", default: "checked_out", null: false
    t.decimal "total_amount_paid", precision: 10, scale: 2
    t.decimal "discounted_price", precision: 10, scale: 2
    t.decimal "amount_without_discount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purchased_at"], name: "index_purchases_on_purchased_at"
    t.index ["status"], name: "index_purchases_on_status"
  end

  create_table "shop_items", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_shop_items_on_name"
  end

end
