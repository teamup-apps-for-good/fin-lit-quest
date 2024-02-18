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
      expense = Expense.create(item: @item, number: 1)
      expect(expense).to be_valid
    end
    it 'fails when an item is not present' do
      expense = Expense.create(number: 1)
      expect(expense).not_to be_valid
    end
  end

  describe 'expense must be for a number bigger than 0' do
    it 'succeeds for a number bigger than 0' do
      expense = Expense.create(item: @item, number: 1)
      expect(expense).to be_valid
    end
    it 'fails for a number less than 1' do
      expense = Expense.create(item: @item, number: 0)
      expect(expense).not_to be_valid
    end
  end

  describe 'validate_max_number_based_on_day_or_week' do
    context 'when it is a daily expense' do
      it 'succeeds within 7 days a week' do
        expense = Expense.create(item: @item, frequency: 'day', number: 7)
        expect(expense).to be_valid
      end
      it 'fails beyond 7 days a week' do
        expense = Expense.create(item: @item, frequency: 'day', number: 8)
        expect(expense).not_to be_valid
      end
    end
    context 'when it is a weekly expense' do
      it 'succeeds for 4 weeks within a month' do
        expense = Expense.create(item: @item, frequency: 'week', number: 4)
        expect(expense).to be_valid
      end
      it 'fails for going beyond 4 weeks' do
        expense = Expense.create(item: @item, frequency: 'week', number: 5)
        expect(expense).not_to be_valid
      end
    end
  end
end
