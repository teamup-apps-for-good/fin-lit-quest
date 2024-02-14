# frozen_string_literal: true

# character_inventory_service.rb

# Service class to handle the logic for character inventory in the game.
class CharacterInventoryService
  def self.fetch_character_and_inventory_by_id(id_param)
    character = Character.find(id_param)
    player_character = Character.find_by(type: 'Player')
    player_inventory = InventoryService.inventory_for(player_character)
    npc_inventory = InventoryService.inventory_for(character)

    [character, player_character, player_inventory, npc_inventory]
  end

  def self.build_context_by_id(id_param)
    character, player_character, player_inventory, npc_inventory =
      fetch_character_and_inventory_by_id(id_param)

    Context.new(
      id: id_param,
      character:,
      player_character:,
      player_inventory:,
      npc_inventory:
    )
  end
end
