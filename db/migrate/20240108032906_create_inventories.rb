class CreateInventories < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories do |t|
      t.integer :item
      t.references :owner, null: false, foreign_key: { to_table: :characters }
      t.integer :quantity, limit: 64

      t.timestamps
    end
  end
end
