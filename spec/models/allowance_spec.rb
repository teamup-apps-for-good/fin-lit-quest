# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allowance, type: :model do
  describe 'validation' do
    before do
      item = Item.new({ name: 'test item', description: 'test', value: 1 })

      @allowance_data = { item:, quantity: 2, level: 1 }
    end

    it 'allows valid objects' do
      data = @allowance_data
      a = Allowance.new(data)
      expect(a.valid?).to be true
    end

    it 'allows null items' do
      data = @allowance_data
      data[:item] = nil
      a = Allowance.new(data)
      expect(a.valid?).to be true
    end

    %i[level quantity].each do |tag|
      it "makes sure #{tag} exists" do
        data = @allowance_data
        data[tag] = nil
        a = Allowance.new(data)
        expect(a.valid?).to be false
      end

      it "ensures #{tag} is poative" do
        data = @allowance_data
        data[:quantity] = -1
        a = Allowance.new(data)
        expect(a.valid?).to be false
      end

      it "ensures #{tag} is non-zero" do
        data = @allowance_data
        data[:quantity] = 0
        a = Allowance.new(data)
        expect(a.valid?).to be false
      end
    end
  end

  describe 'advance_and_credit' do
    before do
      @player = Character.create!(name: 'John Doe', current_level: 1, balance: 0)
      @item = Item.create!(name: 'test item', description: 'test', value: 1)
      @allowance = Allowance.create!(item: @item, level: 1, quantity: 2)
      @nil_allowance = Allowance.create!(item: nil, level: 1, quantity: 10)
      @high_level_allowance = Allowance.create!(item: nil, level: 10, quantity: 5)
    end

    after do
      Character.destroy_all
      Inventory.destroy_all
    end

    it 'does not update player if given nil' do
      Allowance.advance_and_credit(nil)
      inventory = Inventory.find_by(character: @player)
      expect(inventory).to be_nil
      expect(@player.balance).to be(0)
    end

    it 'does not update player on a non-week change' do
      Allowance.advance_and_credit(@player)
      inventory = Inventory.find_by(character: @player)
      expect(inventory).to be_nil
      expect(@player.balance).to be(0)
    end

    it 'does update player on a week change' do
      @player.day = 7
      @player.save!
      Allowance.advance_and_credit(@player)
      inventory = Inventory.find_by(character: @player)
      expect(inventory).not_to be_nil
      expect(@player.balance).to be(10)
    end
  end
end
