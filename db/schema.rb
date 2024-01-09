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

ActiveRecord::Schema[7.1].define(version: 2024_01_09_012904) do
  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.string "occupation"
    t.integer "inventory_slots"
    t.integer "balance"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_level"
    t.string "personality"
    t.text "dialogue_content"
    t.integer "item_to_accept"
    t.integer "quantity_to_accept"
    t.integer "item_to_offer"
    t.integer "quantity_to_offer"
  end

  create_table "inventories", force: :cascade do |t|
    t.integer "item"
    t.integer "owner_id", null: false
    t.integer "quantity", limit: 64
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_inventories_on_owner_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_items_on_name"
  end

  add_foreign_key "inventories", "characters", column: "owner_id"
end
