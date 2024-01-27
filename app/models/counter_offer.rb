# frozen_string_literal: true

# CounterOffer represents a model for handling counter offers in the application.
class CounterOffer < ApplicationRecord
  attr_accessor :item_i_give, :quantity_i_give, :item_i_want, :quantity_i_want

  def change
    create_table :counter_offers do |t|
      t.integer :item_i_give_id
      t.integer :quantity_i_give
      t.integer :item_i_want_id
      t.integer :quantity_i_want
      t.references :character, foreign_key: true

      t.timestamps
    end
  end
end
