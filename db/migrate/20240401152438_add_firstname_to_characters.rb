class AddFirstnameToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :firstname, :string
  end
end
