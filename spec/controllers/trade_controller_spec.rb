# frozen_string_literal: true

# spec/controllers/trade_controller_spec.rb
require 'rails_helper'

RSpec.describe TradeController, type: :controller do
  describe 'GET #trade' do
    before do
      Item.create!(name: 'apple', description: 'crunchy, fresh from the tree', value: 2)
      Item.create!(name: 'orange', description: 'tangy, fresh from the tree', value: 5)
      Nonplayer.create!(name: 'Lightfoot', occupation: :comedian, inventory_slots: 5, balance: 0, personality: :dad,
                        dialogue_content: 'goodbye', current_level: 1,
                        item_to_accept: Item.find_by(name: 'apple'), item_to_offer: Item.find_by(name: 'orange'),
                        quantity_to_accept: 2, quantity_to_offer: 5)
      @nonplayer = Nonplayer.find_by(name: 'Lightfoot')
    end

    it 'should show the correct items to accept for trade' do
      get :trade, params: { id: @nonplayer.id }
      expect(assigns(:item_to_accept)).to eq('apple')
    end
    it 'should show the correct items to offer for trade' do
      get :trade, params: { id: @nonplayer.id }
      expect(assigns(:item_to_offer)).to eq('orange')
    end
  end

  describe 'POST trade_accept' do
    before do
      Item.create!(name: 'apple', description: 'crunchy, fresh from the tree', value: 2)
      Item.create!(name: 'orange', description: 'tangy, fresh from the tree', value: 5)
      Item.create!(name: 'wheat', description: ' grainy, fresh from the field', value: 2)
      Nonplayer.create!(name: 'Lightfoot', occupation: :comedian, inventory_slots: 5, balance: 0, personality: :dad,
                        dialogue_content: 'goodbye', current_level: 1,
                        item_to_accept: Item.find_by(name: 'apple'), item_to_offer: Item.find_by(name: 'orange'),
                        quantity_to_accept: 2, quantity_to_offer: 5)
      Nonplayer.create!(name: 'Ritchey', occupation: :comedian, inventory_slots: 5, balance: 0, personality: :dad,
                        dialogue_content: '431', current_level: 1,
                        item_to_accept: Item.find_by(name: 'wheat'), item_to_offer: Item.find_by(name: 'orange'),
                        quantity_to_accept: 3, quantity_to_offer: 5)                  
      Player.create!(name: 'Stella', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1)
      Player.create!(name: 'Justin', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1)
      @player = Player.find_by(name: 'Stella')
      @player2 = Player.find_by(name: 'Justin')
      @nonplayer = Nonplayer.find_by(name: 'Lightfoot')
      @nonplayer2 = Nonplayer.find_by(name: 'Ritchey')

      Inventory.create!(item: Item.find_by(name: 'apple'),
                        character: @player,
                        quantity: 10)
      Inventory.create!(item: Item.find_by(name: 'wheat'),
                        character: @player,
                        quantity: 2)

      Inventory.create!(item: Item.find_by(name: 'orange'),
                        character: @nonplayer,
                        quantity: 10)

      Inventory.create!(item: Item.find_by(name: 'orange'),
                        character: @nonplayer2,
                        quantity: 10)
        
      Inventory.create!(item: Item.find_by(name: 'apple'),
                        character: @player2,
                        quantity: 10)
      Inventory.create!(item: Item.find_by(name: 'orange'),
                        character: @player2,
                        quantity: 2)

      @npc_inventory = Inventory.where(character: @nonplayer.id)
      @player_inventory = Inventory.where(character: @player.id)
      @player2_inventory = Inventory.where(character: @player2.id)
    end

    it 'should show the correct items to accept for trade' do
      get :trade, params: { id: @nonplayer.id }
      expect(assigns(:item_to_accept)).to eq('apple')
    end

    it 'should add a new item to a player\'s inventory when they complete a trade with an NPC' do
      initial_inventory_count = @player_inventory.count
      post :trade_accept, params: { character_id: @player.id, npc_id: @nonplayer.id, id: '' }
      @player_inventory.reload
      final_inventory_count = @player_inventory.count
      expect(final_inventory_count).to be > initial_inventory_count
    end
    
    it 'should make changes to inventory if trade unsuccessful' do
      initial_inventory_count = @player_inventory.count
      post :trade_accept, params: { character_id: @player.id, npc_id: @nonplayer2.id, id: '' }
      @player_inventory.reload
      final_inventory_count = @player_inventory.count
      expect(final_inventory_count).to be == initial_inventory_count
    end

    it 'should add a increment quantity for item to a player\'s inventory' do
      initial_inventory_count = Inventory.find_by(character: @player2.id, item: Item.find_by(name: 'orange'))
      post :trade_accept, params: { character_id: @player2.id, npc_id: @nonplayer.id, id: '' }
      @player2_inventory.reload
      final_inventory_count = Inventory.find_by(character: @player2.id, item: Item.find_by(name: 'orange'))
      expect(final_inventory_count.quantity).to be > initial_inventory_count.quantity
    end
  end
end
