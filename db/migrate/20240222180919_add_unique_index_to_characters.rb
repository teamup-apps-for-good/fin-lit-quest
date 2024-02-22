class AddUniqueIndexToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_index :characters, [:uid, :provider], unique: true, where: "uid IS NOT NULL AND provider IS NOT NULL"
  end
end
