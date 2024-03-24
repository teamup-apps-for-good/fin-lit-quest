# frozen_string_literal: true

RSpec.describe MessageService do
  let(:validation_service) { instance_double(TradeValidationService) }
  let(:npc) { double('NPC', name: 'NPC Name') }
  let(:total_price) { 100 }

  describe '.generate_buy_error_message' do
    context 'when the player cannot afford the items' do
      it 'returns a message about insufficient funds' do
        allow(validation_service).to receive(:player_can_afford?).with(total_price).and_return(false)

        message = described_class.generate_buy_error_message(validation_service, total_price, npc)

        expect(message).to eq('You do not have enough money to purchase these item(s)')
      end
    end

    context 'when the NPC does not have enough items for the sale' do
      it 'returns a message about the NPC not having enough items' do
        allow(validation_service).to receive(:player_can_afford?).with(total_price).and_return(true)
        allow(validation_service).to receive(:npc_has_item?).and_return(false)

        message = described_class.generate_buy_error_message(validation_service, total_price, npc)

        expect(message).to eq("#{npc.name} does not have enough items for the sale!")
      end
    end
  end

  describe '.generate_sell_error_message' do
    context 'when the user does not have enough items to sell' do
      it 'returns a message about not having enough items to sell' do
        allow(validation_service).to receive(:user_has_item?).and_return(false)

        message = described_class.generate_sell_error_message(validation_service)

        expect(message).to eq('You do not have enough items to sell!')
      end
    end
  end
end
