class CreatePreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :preferences do |t|
      t.string :occupation
      t.references :item, null: false, foreign_key: { to_table: :items }
      t.decimal :multiplier, precision: 3, scale: 2

      t.timestamps
    end
    add_index :preferences, :occupation
  end
end
