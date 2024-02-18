class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.string :frequency
      t.integer :number, limit: 7
      t.references :item, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
