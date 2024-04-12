# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CounterOfferCreateService do
  # Assuming there are factories for characters and items
  let(:current_user) { create(:character, hour: 9) } # A character that is not too late
  let(:npc_character) { create(:character) }
  let(:valid_params) do
    {
      item_i_give_id: '1',
      quantity_i_give: '5',
      item_i_want_id: '2',
      quantity_i_want: '5'
    }
  end

  describe '#execute' do
    context 'when it is too late' do
      before { current_user.hour = 10 }

      it 'returns false with a time message' do
        service = described_class.new(current_user, double, valid_params)
        result, message = service.execute
        expect(result).to be false
        expect(message).to eq('It is too late! Move to the next day')
      end
    end

    context 'when parameters are invalid' do
      let(:invalid_params) { valid_params.except(:item_i_give_id) } # Remove one param to make it invalid

      it 'returns false with a parameter message' do
        service = described_class.new(current_user, double, invalid_params)
        result, message = service.execute
        expect(result).to be false
        expect(message).to eq('Please fill in all required fields')
      end
    end
  end
end
