# frozen_string_literal: true

# spec/controllers/trade_controller_spec.rb
require 'rails_helper'

RSpec.describe TradeController, type: :controller do
  describe 'going up to talk to an npc in town to trade' do
    before do
      Item.create!(name: 'apple', description: 'crunchy, fresh from the tree', value: 2)
      Item.create!(name: 'orange', description: 'tangy, fresh from the tree', value: 5)
      Nonplayer.create!(name: 'Lightfoot', occupation: :comedian, inventory_slots: 5, balance: 0, personality: :dad,
                        dialogue_content: 'goodbye', current_level: 1,
                        item_to_accept: Item.find_by(name: 'apple'), item_to_offer: Item.find_by(name: 'orange'),
                        quantity_to_accept: 2, quantity_to_offer: 5)

      @nonplayer = Nonplayer.find_by(name: 'Lightfoot')
    end
  
    it 'should show the correct items to trade' do
      get :trade, params: { id: @nonplayer.id }
      expect(assigns(:item_to_accept)).to eq('apple')
    end
  end
end