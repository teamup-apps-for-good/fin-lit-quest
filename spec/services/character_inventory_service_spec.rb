# frozen_string_literal: true

require 'rails_helper'
RSpec.describe CharacterInventoryService do
  describe '.fetch_character_and_inventory_by_id' do
    it 'fetches character, player character, and their inventories' do
      character = create(:character)
      player_character = create(:character, :player)
      player_inventory = create(:inventory, character: player_character)
      npc_inventory = create(:inventory, character:)
      result = CharacterInventoryService.fetch_character_and_inventory_by_id(character.id)
      expect(result[0]).to eq(character)
      expect(result[1]).to be_a(Player)
      expect(result[2]).to include(player_inventory.item.name => player_inventory.quantity)
      expect(result[3]).to include(npc_inventory.item.name => npc_inventory.quantity)
    end
  end
  describe '.build_context_by_id' do
    it 'builds a context object with character, player character, and inventories' do
      character = create(:character)
      player_character = create(:character, :player)
      create(:inventory, character: player_character)
      create(:inventory, character:)
      context = CharacterInventoryService.build_context_by_id(character.id)
      expect(context.player_character).to be_a(Player)
      expect(context.player_character.id).to eq(player_character.id)
      expect(context.player_character.name).to eq(player_character.name)
    end
  end
end
