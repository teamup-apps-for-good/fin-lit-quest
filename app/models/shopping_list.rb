# frozen_string_literal: true

# ShoppingList
class ShoppingList < ApplicationRecord
  belongs_to :item

  # if player inventory has item, is in current level, and quantity matches
  # shopping list, then item has been obtained
  def item_obtained(player)
    Inventory.any? do |inventory|
      inventory.item == item && inventory.character == player && inventory.quantity >= quantity
    end
  end
end
