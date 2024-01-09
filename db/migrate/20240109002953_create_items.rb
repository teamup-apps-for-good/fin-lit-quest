class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.integer :value

      t.timestamps
    end
    add_index :items, :name
  end
end
