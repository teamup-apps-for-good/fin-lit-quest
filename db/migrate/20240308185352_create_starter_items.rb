class CreateStarterItems < ActiveRecord::Migration[7.1]
  def change
    create_table :starter_items do |t|
      t.references :item, null: false, foreign_key: true
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
