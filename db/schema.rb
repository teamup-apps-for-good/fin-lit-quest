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

ActiveRecord::Schema[7.1].define(version: 2024_01_08_014833) do
  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.string "occupation"
    t.integer "inventory_slots"
    t.integer "balance"
    t.boolean "is_player"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nonplayers", force: :cascade do |t|
    t.integer "character_id", null: false
    t.string "personality"
    t.string "dialogue_content"
    t.string "item_to_accept"
    t.integer "quantity_to_accept"
    t.string "item_to_offer"
    t.integer "quantity_to_offer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_nonplayers_on_character_id"
  end

  add_foreign_key "nonplayers", "characters"
end
