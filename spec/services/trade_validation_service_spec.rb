# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TradeValidationService do
  let(:player) { create(:character, balance: 100) } # Assuming a factory setup for characters
  let(:npc) { create(:character) } # NPC character
  let(:item_to_give) { create(:item) }
  let(:item_to_want) { create(:item) }
  let(:trade_data) { TradeData.new(item_to_give.id, 5, item_to_want.id, 5) }
  let(:trade_params) { TradeParams.new(player, npc, trade_data) }
  let(:service) { described_class.new(trade_params) }

  describe '#player_can_afford?' do
    context 'when player has enough balance' do
      it 'returns true' do
        # Assuming the total price for the items the player wants is less than or equal to 100
        allow(ValueCalculationService).to receive(:value_of).with(npc, item_to_want.id, 5).and_return(80)
        expect(service.player_can_afford?(80)).to be true
      end
    end

    context 'when player does not have enough balance' do
      it 'returns false' do
        # Assuming the total price for the items the player wants is more than 100
        allow(ValueCalculationService).to receive(:value_of).with(npc, item_to_want.id, 5).and_return(120)
        expect(service.player_can_afford?(120)).to be false
      end
    end
  end
end
