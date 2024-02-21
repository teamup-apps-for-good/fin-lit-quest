class AddOauthDetailsToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :uid, :string
    add_column :characters, :provider, :string
  end
end
