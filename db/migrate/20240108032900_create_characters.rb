class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :occupation
      t.integer :inventory_slots
      t.integer :balance
      t.string :type

      t.timestamps
    end
  end
end
