# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpensesHelper, type: :helper do
  before do
    @character = Character.create(name: 'Stella',
                                  occupation: :farmer,
                                  inventory_slots: 20,
                                  balance: 0,
                                  current_level: 1)
  end

  after do
    Inventory.destroy_all
    Character.destroy_all
    Item.destroy_all
  end

  context 'an expense exists' do
    before do
      item = Item.create(name: 'test item', description: 'test', value: 1)
      Expense.create(item:, number: 1, frequency: 'day', quantity: 2)
      Expense.create(item:, number: 1, frequency: 'week', quantity: 2)
    end

    after do
      Expense.destroy_all
    end

    describe 'display_today_expense_for_character' do
      it 'displays todays expense' do
        expect(ExpensesHelper.display_today_expense_for_character(@character)).to eq('Expenses for today: 2 test item')
      end
    end

    describe 'display_this_week_expense_for_character' do
      it 'displays this weeks expense' do
        expect(ExpensesHelper.display_this_week_expense_for_character(@character)).to eq('Expenses for this week: 2 test item')
      end
    end
  end

  describe 'display_expense_for_character' do
    it 'does not display expense if it does not exist' do
      expect(ExpensesHelper.display_today_expense_for_character(@character)).to eq('')
    end
  end
end
