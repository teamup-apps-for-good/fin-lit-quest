class CreateCounterOffers < ActiveRecord::Migration[7.1]
  def change
    create_table :counter_offers do |t|

      t.timestamps
    end
  end
end
