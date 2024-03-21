class CreateAllowances < ActiveRecord::Migration[7.1]
  def change
    create_table :allowances do |t|
      t.integer :level, null: false
      t.references :item, foreign_key: true
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
