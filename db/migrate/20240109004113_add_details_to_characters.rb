class AddDetailsToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :personality, :string
    add_column :characters, :dialogue_content, :text
    add_column :characters, :item_to_accept, :integer
    add_column :characters, :quantity_to_accept, :integer
    add_column :characters, :item_to_offer, :integer
    add_column :characters, :quantity_to_offer, :integer
  end
end
