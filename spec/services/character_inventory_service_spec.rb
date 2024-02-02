# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CharacterInventoryService do
  describe '.fetch_character_and_inventory' do
    it 'fetches character, player character, and their inventories' do
      character = create(:character)
      player_character = create(:character, :player)
      player_inventory = create(:inventory, character: player_character)
      npc_inventory = create(:inventory, character:)

      result = CharacterInventoryService.fetch_character_and_inventory(character.name)

      expect(result[0]).to eq(character)
      expect(result[1]).to be_an_instance_of(Player) # Check if it's a Player instance
      expect(result[2][player_inventory.item.name]).to eq(player_inventory.quantity) # Compare quantity
      expect(result[3][npc_inventory.item.name]).to eq(npc_inventory.quantity) # Compare quantity
    end
  end

  describe '.build_context' do
    it 'builds a context object with character, player character, and inventories' do
      character = create(:character)
      player_character = create(:character, :player)
      player_inventory = create(:inventory, character: player_character)
      npc_inventory = create(:inventory, character:)

      context = CharacterInventoryService.build_context(character.name)

      expect(context.name).to eq(character.name)
      expect(context.character).to be_an_instance_of(Character) # Check if it's an instance of Character
      expect(context.player_character).to be_an_instance_of(Player) # Check if it's an instance of Player
      expect(context.player_inventory[player_inventory.item.name]).to eq(player_inventory.quantity) # Compare quantity
      expect(context.npc_inventory[npc_inventory.item.name]).to eq(npc_inventory.quantity) # Compare quantity
    end
  end
end
