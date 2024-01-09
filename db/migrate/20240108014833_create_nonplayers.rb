# frozen_string_literal: true

# Make nonplayers table with foreign key references
class CreateNonplayers < ActiveRecord::Migration[7.1]
  def change
    create_table :nonplayers do |t|
      t.references :character, null: false, foreign_key: true
      t.string :personality
      t.string :dialogue_content
      t.string :item_to_accept
      t.integer :quantity_to_accept
      t.string :item_to_offer
      t.integer :quantity_to_offer
      t.timestamps
    end
  end
end
