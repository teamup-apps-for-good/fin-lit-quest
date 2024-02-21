# frozen_string_literal: true

# character_inventory_service.rb

# Service class to handle the logic for character inventory in the game.
class CharacterInventoryService
  def self.fetch_character_and_inventory_by_id(id_param, current_user)
    character = Character.find(id_param)
    player_character = Character.find_by(name: current_user.name)
    player_inventory = InventoryService.inventory_for(player_character)
    npc_inventory = InventoryService.inventory_for(character)

    [character, player_character, player_inventory, npc_inventory]
  end

  def self.build_context_by_id(id_param, current_user)
    character, player_character, player_inventory, npc_inventory =
      fetch_character_and_inventory_by_id(id_param, current_user)

    Context.new(
      id: id_param,
      character:,
      player_character:,
      player_inventory:,
      npc_inventory:
    )
  end
end
