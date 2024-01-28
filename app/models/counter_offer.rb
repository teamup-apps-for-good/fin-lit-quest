# frozen_string_literal: true

# CounterOffer represents a model for handling counter offers in the application.
class CounterOffer < ApplicationRecord
  # Associations (adjust these according to your application's relationships)
  # Validations
  validates :item_i_give_id, presence: true
  validates :quantity_i_give, presence: true, numericality: { greater_than: 0 }
  validates :item_i_want_id, presence: true
  validates :quantity_i_want, presence: true, numericality: { greater_than: 0 }
end
