class CreateNonplayers < ActiveRecord::Migration[7.1]
  def change
    create_table :nonplayers do |t|
      t.references :character, null: false, foreign_key: true
      t.string :personality
      t.references :dialogue, null: false, foreign_key: true

      t.timestamps
    end
  end
end
