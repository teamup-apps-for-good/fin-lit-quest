class CreateShoppingLists < ActiveRecord::Migration[7.1]
  def change
    create_table :shopping_lists do |t|
      t.references :item, null: false, foreign_key: { to_table: :items }
      t.integer :level
      t.integer :quantity

      t.timestamps
    end
  end
end
