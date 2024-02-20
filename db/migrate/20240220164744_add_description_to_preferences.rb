class AddDescriptionToPreferences < ActiveRecord::Migration[7.1]
  def change
    add_column :preferences, :description, :text
  end
end
