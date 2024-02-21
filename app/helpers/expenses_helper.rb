# frozen_string_literal: true

# Rendering the items in the expenses
module ExpensesHelper
  def self.display_today_expense_for_character(character)
    display_expense_for_character(character, method(:Expense.today_expense))
  end

  def self.display_this_week_expense_for_character(character)
    display_expense_for_character(character, method(:Expense.this_week_expense))
  end

  def self.display_expense_for_character(character, expense_method)
    return 'Character details incomplete or not found.' unless character.present?

    expense = expense_method.call(character.day)
    if expense
      "Expenses for #{expense_method.name.split('_').first}: #{expense.quantity} #{expense.item.name}"
    else
      ''
    end
  end

  private_class_method :display_expense_for_character
end
