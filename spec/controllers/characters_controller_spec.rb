# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CharactersController, type: :controller do
  describe 'Admin access' do
    let(:valid_attributes) do
      # Define valid attributes for your character model
      { name: 'Test Character', occupation: 'Test Occupation', inventory_slots: 10, balance: 100, type: 'Character' }
    end

    describe 'GET #index' do
      it 'returns a success response' do
        Character.create! valid_attributes
        get :index, params: {}
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        character = Character.create! valid_attributes
        get :show, params: { id: character.to_param }
        expect(response).to be_successful
      end
    end
  end

  describe 'going up to talk to an npc in town' do
    before(:each) do
      Item.create!(name: 'apple', description: 'crunchy, fresh from the tree', value: 2)
      Item.create!(name: 'orange', description: 'test description', value: 5)
      Nonplayer.create!(name: 'Lightfoot', occupation: :comedian, inventory_slots: 5, balance: 0, personality: :dad,
                        dialogue_content: 'goodbye', current_level: 1,
                        item_to_accept: Item.find_by(name: 'apple'), item_to_offer: Item.find_by(name: 'orange'),
                        quantity_to_accept: 2, quantity_to_offer: 5)
    end
    it 'should show the profile with some attributes of the npc' do
      nonplayer = Nonplayer.find_by(name: 'Lightfoot')
      get :profile, params: { id: nonplayer.id }
      expect(assigns(:character)).to eq(nonplayer)
    end
    it 'should show the inventory of the npc' do
      nonplayer = Nonplayer.find_by(name: 'Lightfoot')
      get :inventory, params: { id: nonplayer.id }
      expect(assigns(:inventories)).to eq(nonplayer.inventories)
    end
    it 'should show the correct items to trade' do
      nonplayer = Nonplayer.find_by(name: 'Lightfoot')
      get :trade, params: { id: nonplayer.id }
      expect(assigns(:item_to_accept)).to eq('apple')
    end
  end
end
