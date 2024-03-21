class AddAdminFieldToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :admin, :boolean
  end
end
