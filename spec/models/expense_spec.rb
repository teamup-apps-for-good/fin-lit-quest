# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expense', type: :model do
  before do
    @item = Item.create(name: 'apple', description: 'crunchy, fresh from the tree', value: 2)
  end

  after do
    Expense.destroy_all
    Item.destroy_all
  end

  describe 'expense must have an item' do
    it 'succeeds when an item is present' do
      expense = Expense.create(item: @item, number: 1, frequency: 'day', quantity: 1)
      expect(expense).to be_valid
    end
    it 'fails when an item is not present' do
      expense = Expense.create(number: 1)
      expect(expense).not_to be_valid
    end
  end

  describe 'expense must be for a number bigger than 0' do
    it 'succeeds for a number bigger than 0' do
      expense = Expense.create(item: @item, number: 1, frequency: 'day', quantity: 1)
      expect(expense).to be_valid
    end
    it 'fails for a number less than 1' do
      expense = Expense.create(item: @item, number: 0, frequency: 'day', quantity: 1)
      expect(expense).not_to be_valid
    end
  end

  describe 'expense must be for item quantities bigger than 0' do
    it 'succeeds for a quantity bigger than 0' do
      expense = Expense.create(item: @item, number: 1, frequency: 'day', quantity: 1)
      expect(expense).to be_valid
    end
    it 'fails for a quantity less than 1' do
      expense = Expense.create(item: @item, number: 1, frequency: 'day', quantity: 0)
      expect(expense).not_to be_valid
    end
  end

  describe 'validate_max_number_based_on_day_or_week' do
    context 'when it is a daily expense' do
      it 'succeeds within 7 days a week' do
        expense = Expense.create(item: @item, frequency: 'day', number: 7, quantity: 1)
        expect(expense).to be_valid
      end
      it 'fails beyond 7 days a week' do
        expense = Expense.create(item: @item, frequency: 'day', number: 8, quantity: 1)
        expect(expense).not_to be_valid
      end
    end
    context 'when it is a weekly expense' do
      it 'succeeds for 4 weeks within a month' do
        expense = Expense.create(item: @item, frequency: 'week', number: 4, quantity: 1)
        expect(expense).to be_valid
      end
      it 'fails for going beyond 4 weeks' do
        expense = Expense.create(item: @item, frequency: 'week', number: 5, quantity: 1)
        expect(expense).not_to be_valid
      end
    end
  end

  describe 'today_expense' do
    it 'returns the expense for today' do
      expense = Expense.create(item: @item, frequency: 'day', number: 1, quantity: 1)
      expect(Expense.today_expense(1)).to eq(expense)
    end
  end

  describe 'this_week_expense' do
    it 'returns the expense for this week' do
      expense = Expense.create(item: @item, frequency: 'week', number: 1, quantity: 1)
      expect(Expense.this_week_expense(1)).to eq(expense)
    end
  end

  describe 'advance_and_deduct?' do
    before do
      @player = Character.create(name: 'John Doe')
      @inventory = Inventory.create(item: @item, character: @player, quantity: 1)
    end

    after do
      Character.destroy_all
      Inventory.destroy_all
    end

    it 'returns false when player is nil' do
      Expense.create(item: @item, number: 1, frequency: 'day', quantity: 1)
      expect(Expense.advance_and_deduct?(nil)).to be false
    end

    it 'returns true when player has the item' do
      Expense.create(item: @item, number: 1, frequency: 'day', quantity: 1)
      expect(Expense.advance_and_deduct?(@player)).to be true
    end

    it 'returns false when player does not have the item' do
      Expense.create(item: @item, number: 1, frequency: 'day', quantity: 2)
      expect(Expense.advance_and_deduct?(@player)).to be false
    end
  end
end
