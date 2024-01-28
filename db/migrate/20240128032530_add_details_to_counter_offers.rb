class AddDetailsToCounterOffers < ActiveRecord::Migration[7.1]
  def change
    add_column :counter_offers, :item_i_give_id, :integer
    add_column :counter_offers, :quantity_i_give, :integer
    add_column :counter_offers, :item_i_want_id, :integer
    add_column :counter_offers, :quantity_i_want, :integer
  end
end
