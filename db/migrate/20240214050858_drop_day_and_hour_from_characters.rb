class DropDayAndHourFromCharacters < ActiveRecord::Migration[7.1]
  def change
    remove_column :characters, :day, :integer
    remove_column :characters, :hour, :integer
  end
end
