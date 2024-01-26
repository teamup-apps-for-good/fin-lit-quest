# frozen_string_literal: true

# ShoppingList
class ShoppingList < ApplicationRecord
  belongs_to :item

  # if player inventory has item, is in current level, and quantity matches
  # shopping list, then item has been obtained
  def item_obtained(player)
    Inventory.where(character: player).each do |inventory_item|
      return true if inventory_item.item == item && inventory_item.quantity >= quantity
    end
    false
  end
end
