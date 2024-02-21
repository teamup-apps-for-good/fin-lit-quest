class AddEmailToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :email, :string
  end
end
