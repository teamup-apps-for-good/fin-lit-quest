# frozen_string_literal: true

# Rendering the items in the expenses
module ExpensesHelper
  def self.display_today_expense_for_character(character)
    display_expense_for_character(character, :today_expense)
  end

  def self.display_this_week_expense_for_character(character)
    display_expense_for_character(character, :this_week_expense)
  end

  def self.display_expense_for_character(character, expense_method)
    return 'Character details incomplete or not found.' unless character.present?

    expense = Expense.send(expense_method, character.day)
    if expense
      expense_name = expense_method.to_s.split('_expense').first.gsub('_', ' ')
      "Expenses for #{expense_name}: #{expense.quantity} #{expense.item.name}"
    else
      ''
    end
  end

  private_class_method :display_expense_for_character
end
