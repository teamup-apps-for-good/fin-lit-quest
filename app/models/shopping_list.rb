# frozen_string_literal: true

# ShoppingList
class ShoppingList < ApplicationRecord
  belongs_to :item
end
