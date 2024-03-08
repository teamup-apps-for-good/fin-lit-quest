# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StarterItem, type: :model do
  describe 'validation' do
    before do
      item = Item.new({ name: 'test item', description: 'test', value: 1 })

      @starter_data = { item:, quantity: 2 }
    end

    it 'allows valid objects' do
      data = @starter_data
      si = StarterItem.new(data)
      expect(si.valid?).to be true
    end

    %i[item quantity].each do |tag|
      it "makes sure #{tag} exists" do
        data = @starter_data
        data[tag] = nil
        si = StarterItem.new(data)
        expect(si.valid?).to be false
      end
    end

    it 'ensures quantity is positive' do
      data = @starter_data
      data[:quantity] = -1
      si = StarterItem.new(data)
      expect(si.valid?).to be false
    end

    it 'ensures quantity is non-zero' do
      data = @starter_data
      data[:quantity] = 0
      si = StarterItem.new(data)
      expect(si.valid?).to be false
    end
  end
end
