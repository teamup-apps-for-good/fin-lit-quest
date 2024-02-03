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
end
