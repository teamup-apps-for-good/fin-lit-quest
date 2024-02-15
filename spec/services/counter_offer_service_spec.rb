# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CounterOfferService do
  let(:item_to_give) { create(:item) }
  let(:item_to_want) { create(:item) }
  let(:player_character) { create(:character, :player) }
  let(:npc_character) { create(:character) }

  let(:offer_params) do
    {
      item_i_give_id: item_to_give.id,
      quantity_i_give: 5,
      item_i_want_id: item_to_want.id,
      quantity_i_want: 5
    }
  end

  subject(:service) { described_class.new(player_character, npc_character, offer_params) }

  describe '#execute_trade' do
    context 'when the trade is valid and items are available' do
      before do
        create(:inventory, character: player_character, item: item_to_give, quantity: 5)
        create(:inventory, character: npc_character, item: item_to_want, quantity: 5)
      end

      it 'returns true and performs the trade' do
        result, message = service.execute_trade

        expect(result).to be true
        expect(message).to be_empty

        # Optionally verify inventory updates
        updated_player_give_inventory = Inventory.find_by(character: player_character, item: item_to_give)
        updated_npc_want_inventory = Inventory.find_by(character: npc_character, item: item_to_want)

        updated_player_give_inventory.reload
        updated_npc_want_inventory.reload
      end
    end

    context 'when the NPC does not have the item' do
      before do
        create(:inventory, character: player_character, item: item_to_give, quantity: 5)
        # Do not create inventory for npc_character to simulate absence of the item
      end

      it 'returns false with an appropriate error message' do
        result, message = service.execute_trade
        expect(result).to be false
        expect(message).to include('does not have the item you are trying to get')
      end
    end

    context 'when the trade is not valid due to valuation' do
      let(:item_to_give) { create(:item, value: 10) }
      let(:item_to_want) { create(:item, value: 100) }

      before do
        create(:inventory, character: player_character, item: item_to_give, quantity: 5)
        create(:inventory, character: npc_character, item: item_to_want, quantity: 5)
        # Ensure the service is re-initialized if needed to pick up new `let` values
        described_class.new(player_character, npc_character, offer_params)
      end

      it 'returns false with a valuation error message' do
        result, message = service.execute_trade
        expect(result).to be false
        expect(message).to include("#{npc_character.name} did not accept your offer!")
      end
    end
  end

  describe 'when given the same items with higher price to trade to different occupations' do
    before do
      Item.create(name: 'apple',
                  description: 'crunchy, fresh from the tree',
                  value: 2)

      Item.create(name: 'bread',
                  description: 'yummy, fresh from the oven',
                  value: 2)

      Character.create(name: 'Bobert',
                       occupation: :farmer,
                       inventory_slots: 20,
                       balance: 0,
                       current_level: 1)

      Character.create(name: 'Robert',
                       occupation: :merchant,
                       inventory_slots: 20,
                       balance: 0,
                       current_level: 1)

      @bobert = Character.find_by(name: 'Bobert')
      @robert = Character.find_by(name: 'Robert')

      @apple_item = Item.find_by(name: 'apple')
      @bread_item = Item.find_by(name: 'bread')

      Preference.create(occupation: 'merchant',
                        item: @bread_item,
                        multiplier: 3)
      Preference.create(occupation: 'farmer',
                        item: @apple_item,
                        multiplier: 2)

      @pref = Preference.find_by(occupation: @robert.occupation)
    end

    after do
      Preference.destroy_all
      Character.destroy_all
      Item.destroy_all
    end

    it 'should be accepted by an occupation that prefers it' do
      trade = described_class.new(player_character, @bobert,
                                  { item_i_give_id: @apple_item.id, quantity_i_give: 1,
                                    item_i_want_id: @bread_item.id, quantity_i_want: 2 })
      expect(trade.valid_trade?).to eq(true)
    end

    it 'should be rejecteded by an occupation that does not prefer it' do
      trade = described_class.new(player_character, @robert,
                                  { item_i_give_id: @apple_item.id, quantity_i_give: 1,
                                    item_i_want_id: @bread_item.id, quantity_i_want: 2 })
      expect(trade.valid_trade?).to eq(false)
    end
  end
end
