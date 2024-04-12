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

ActiveRecord::Schema[7.1].define(version: 2024_04_01_152438) do
  create_table "allowances", force: :cascade do |t|
    t.integer "level", null: false
    t.integer "item_id"
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_allowances_on_item_id"
  end

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
    t.integer "quantity_to_accept"
    t.integer "quantity_to_offer"
    t.integer "item_to_accept_id"
    t.integer "item_to_offer_id"
    t.integer "day", default: 1
    t.integer "hour", default: 1
    t.string "uid"
    t.string "provider"
    t.string "email"
    t.boolean "admin"
    t.string "firstname"
    t.index ["item_to_accept_id"], name: "index_characters_on_item_to_accept_id"
    t.index ["item_to_offer_id"], name: "index_characters_on_item_to_offer_id"
    t.index ["uid", "provider"], name: "index_characters_on_uid_and_provider", unique: true, where: "uid IS NOT NULL AND provider IS NOT NULL"
  end

  create_table "expenses", force: :cascade do |t|
    t.string "frequency"
    t.integer "number", limit: 7
    t.integer "item_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_expenses_on_item_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "character_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_inventories_on_character_id"
    t.index ["item_id"], name: "index_inventories_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_items_on_name"
  end

  create_table "preferences", force: :cascade do |t|
    t.string "occupation"
    t.integer "item_id", null: false
    t.decimal "multiplier", precision: 3, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["item_id"], name: "index_preferences_on_item_id"
    t.index ["occupation"], name: "index_preferences_on_occupation"
  end

  create_table "shopping_lists", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "level"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_shopping_lists_on_item_id"
  end

  create_table "starter_items", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_starter_items_on_item_id"
  end

  add_foreign_key "allowances", "items"
  add_foreign_key "characters", "items", column: "item_to_accept_id"
  add_foreign_key "characters", "items", column: "item_to_offer_id"
  add_foreign_key "expenses", "items"
  add_foreign_key "inventories", "characters"
  add_foreign_key "inventories", "items"
  add_foreign_key "preferences", "items"
  add_foreign_key "shopping_lists", "items"
  add_foreign_key "starter_items", "items"
end
