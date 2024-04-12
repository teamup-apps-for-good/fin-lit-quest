# frozen_string_literal: true

# spec/services/price_calculation_service_spec.rb
require 'rails_helper'

RSpec.describe PriceCalculationService do
  let(:user) { instance_double(Player) }
  let(:context) { double('Context', character:) }
  let(:character) { instance_double(Character) }
  let(:item) { instance_double(Item) }
  let(:item_id) { 1 }
  let(:quantity) { 5 }

  subject { described_class.new(user, context) }

  describe '#calculate_total_price' do
    context 'when transaction_type is buy' do
      let(:transaction_type) { 'buy' }
      let(:unit_price) { 10 }

      before do
        allow(Item).to receive(:find).with(item_id).and_return(item)
        allow(ValueCalculationService).to receive(:value_of).with(character, item_id, 1).and_return(unit_price)
      end

      it 'calculates the total price for buying an item' do
        expect(subject.calculate_total_price(item_id, quantity, transaction_type)).to eq(unit_price * quantity)
      end
    end

    context 'when transaction_type is sell' do
      let(:transaction_type) { 'sell' }
      let(:unit_price) { 8 }

      before do
        allow(Item).to receive(:find).with(item_id).and_return(item)
        allow(ValueCalculationService).to receive(:value_of).with(user, item_id, 1).and_return(unit_price)
      end

      it 'calculates the total price for selling an item' do
        expect(subject.calculate_total_price(item_id, quantity, transaction_type)).to eq(unit_price * quantity)
      end
    end
  end

  describe '#calculate_unit_price' do
    context 'when transaction_type is buy' do
      let(:transaction_type) { 'buy' }
      let(:unit_price) { 10 }

      before do
        allow(ValueCalculationService).to receive(:value_of).with(character, item_id, 1).and_return(unit_price)
      end

      it 'calculates the unit price for buying an item' do
        expect(subject.send(:calculate_unit_price, transaction_type, item_id)).to eq(unit_price)
      end
    end

    context 'when transaction_type is sell' do
      let(:transaction_type) { 'sell' }
      let(:unit_price) { 8 }

      before do
        allow(ValueCalculationService).to receive(:value_of).with(user, item_id, 1).and_return(unit_price)
      end

      it 'calculates the unit price for selling an item' do
        expect(subject.send(:calculate_unit_price, transaction_type, item_id)).to eq(unit_price)
      end
    end
  end
end
