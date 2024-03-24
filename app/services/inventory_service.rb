# frozen_string_literal: true

# Service class for managing inventory updates.
# Provides functionalities to add, remove, or update inventory items.
class InventoryService
  def self.update_inventory(character, item_id, quantity_change)
    inventory_item = character.inventories.find_by(item_id:)

    if inventory_item
      new_quantity = inventory_item.quantity + quantity_change
      update_or_log_error(inventory_item, new_quantity, item_id)
    elsif quantity_change.positive?
      character.inventories.create!(item_id:, quantity: quantity_change)
    end
  end

  def self.update_or_log_error(inventory_item, new_quantity, item_id)
    unless new_quantity >= 0
      raise NegativeInventoryError,
            "Invalid quantity for item #{item_id} for character #{inventory_item.character.id}"
    end

    inventory_item.update!(quantity: new_quantity)
  end

  def self.inventory_for(character)
    character.inventories.includes(:item).each_with_object({}) do |inventory, hash|
      hash[inventory.item.name] = inventory.quantity
    end
  end

  def self.set_inventory(character, item_id, quantity)
    item = Item.find_by(id: item_id)
    return unless item

    inventory_item = character.inventories.find_or_initialize_by(item:)
    inventory_item.quantity = quantity
    inventory_item.save!
  end
end
