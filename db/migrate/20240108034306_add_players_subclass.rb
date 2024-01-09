class AddPlayersSubclass < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :current_level, :integer
    add_column :characters, :type, :string
  end
end
