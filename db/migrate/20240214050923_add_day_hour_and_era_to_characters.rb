class AddDayHourAndEraToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :day, :integer, default: 1
    add_column :characters, :hour, :integer, default: 8
    add_column :characters, :era, :integer, default: 1
  end
end
