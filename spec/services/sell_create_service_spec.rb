# frozen_string_literal: true

# spec/services/sell_create_service_spec.rb
require 'rails_helper'

RSpec.describe SellCreateService do
  let(:current_user) { create(:character, :player) }
  let(:context) { double('context', player_character:, character: npc_character) }
  let(:player_character) { current_user }
  let(:npc_character) { create(:character) }
  let(:item) { create(:item) }
  let(:params) { { item_i_give_id: item.id, quantity_i_give: '5' } }

  subject(:service) { described_class.new(current_user, context, params) }

  describe '#execute' do
    context 'when it is too late' do
      before do
        allow(current_user).to receive(:hour).and_return(10)
      end

      it 'returns false with an appropriate message' do
        result, message = service.execute
        expect(result).to be false
        expect(message).to eq('It is too late! Move to the next day')
      end
    end

    context 'when sell params are invalid' do
      let(:params) { { item_i_give_id: nil, quantity_i_give: nil } }

      it 'returns false with an appropriate message' do
        result, message = service.execute
        expect(result).to be false
        expect(message).to eq('Please fill in all required fields for sell')
      end
    end

    context 'when sell is successful' do
      let(:counter_offer_service) { instance_double(CounterOfferService) }

      before do
        allow(CounterOfferService).to receive(:new).and_return(counter_offer_service)
        allow(counter_offer_service).to receive(:execute_sell).and_return([true, 'Sell success!'])
        allow(TimeAdvancementHelper).to receive(:increment_hour)
      end

      it 'creates a CounterOfferService instance and executes the sell' do
        expect(CounterOfferService).to receive(:new).with(player_character, npc_character, params)
        expect(counter_offer_service).to receive(:execute_sell)
        service.execute
      end

      it 'increments the hour for the current user' do
        expect(TimeAdvancementHelper).to receive(:increment_hour).with(current_user)
        service.execute
      end

      it 'returns true with a success message' do
        result, message = service.execute
        expect(result).to be true
        expect(message).to eq('Sell success!')
      end
    end

    context 'when sell is unsuccessful' do
      let(:counter_offer_service) { instance_double(CounterOfferService) }

      before do
        allow(CounterOfferService).to receive(:new).and_return(counter_offer_service)
        allow(counter_offer_service).to receive(:execute_sell).and_return([false, 'Sell failed!'])
      end

      it 'does not increment the hour for the current user' do
        expect(TimeAdvancementHelper).not_to receive(:increment_hour)
        service.execute
      end

      it 'returns false with an error message' do
        result, message = service.execute
        expect(result).to be false
        expect(message).to eq('Sell failed!')
      end
    end
  end
end
