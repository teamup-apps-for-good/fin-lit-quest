# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe 'validation' do
    before do
      item = Item.new({ name: 'test item', description: 'test', value: 1 })
      character = Character.create(name: 'Stella',
                                   occupation: :farmer,
                                   inventory_slots: 20,
                                   balance: 0,
                                   current_level: 1)
      @inventory_data = {
        item:,
        character:,
        quantity: 1
      }
    end

    it 'allows valid objects' do
      data = @inventory_data
      inventory = Inventory.new(data)
      expect(inventory.valid?).to be true
    end

    %i[item character quantity].each do |tag|
      it "makes sure #{tag} exists" do
        data = @inventory_data
        data[tag] = nil
        inventory = Inventory.new(data)
        expect(inventory.valid?).to be false
      end
    end

    it 'ensures quantity is positive' do
      data = @inventory_data
      data[:quantity] = -1
      inventory = Inventory.new(data)
      expect(inventory.valid?).to be false
    end
  end
  context 'expenses' do
    before do
      item = Item.create(name: 'test item', description: 'test', value: 1)
      character = Character.create(name: 'Stella',
                                   occupation: :farmer,
                                   inventory_slots: 20,
                                   balance: 0,
                                   current_level: 1)
      @inventory = Inventory.create(item:, character:, quantity: 5)
      @expense = Expense.create(item:, number: 1, frequency: 'day', quantity: 2)
    end

    after do
      Expense.destroy_all
      Inventory.destroy_all
      Character.destroy_all
      Item.destroy_all
    end

    describe 'deduct_expense' do
      it 'deducts the expense' do
        Inventory.deduct_expense(@inventory.character, @expense)
        expect(@inventory.reload.quantity).to eq(3)
      end
    end

    describe 'satisfy_expense?' do
      it 'returns true when expense is nil' do
        expect(Inventory.satisfy_expense?(@inventory.character, nil, nil)).to be true
      end

      it 'returns true when expense is satisfied' do
        expect(Inventory.satisfy_expense?(@inventory.character, @expense, nil)).to be true
      end

      it 'returns false when expense is not satisfied' do
        expense = Expense.create(item: @inventory.item, number: 1, frequency: 'day', quantity: 6)
        expect(Inventory.satisfy_expense?(@inventory.character, expense, nil)).to be false
      end

      it 'returns true when two expenses are satisfied' do
        expense1 = Expense.create(item: @inventory.item, number: 1, frequency: 'day', quantity: 1)
        expense2 = Expense.create(item: @inventory.item, number: 1, frequency: 'day', quantity: 1)
        expect(Inventory.satisfy_expense?(@inventory.character, expense1, expense2)).to be true
      end

      it 'returns false when one of the two expenses is not satisfied' do
        expense1 = Expense.create(item: @inventory.item, number: 1, frequency: 'day', quantity: 1)
        expense2 = Expense.create(item: @inventory.item, number: 1, frequency: 'day', quantity: 6)
        expect(Inventory.satisfy_expense?(@inventory.character, expense1, expense2)).to be false
      end
    end
  end
end
