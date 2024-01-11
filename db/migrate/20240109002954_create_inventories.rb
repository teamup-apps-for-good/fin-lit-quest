class CreateInventories < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories do |t|
      t.references :item, null: false, foreign_key: { to_table: :items }
      t.references :character, null: false, foreign_key: { to_table: :characters }
      t.integer :quantity

      t.timestamps
    end
  end
end
