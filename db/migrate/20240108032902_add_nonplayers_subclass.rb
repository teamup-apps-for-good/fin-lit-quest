class AddNonplayersSubclass < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :personality, :string
    add_column :characters, :dialogue_content, :text
    add_column :characters, :quantity_to_accept, :integer
    add_column :characters, :quantity_to_offer, :integer

    change_table :characters do |t|
      t.references :item_to_accept, null: true, foreign_key: { to_table: :items }
      t.references :item_to_offer, null: true, foreign_key: { to_table: :items }
    end
  end
end
