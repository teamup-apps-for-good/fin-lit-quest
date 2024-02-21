# frozen_string_literal: true

# Rendering the items in the expenses
module ExpensesHelper
  def self.display_expense_for_character(character)
    return 'Character details incomplete or not found.' unless character.present?

    today_expense = Expense.today_expense(character.day)
    weekly_expense = Expense.this_week_expense(character.day)
    output = ''
    output += "Expenses for today: #{today_expense.quantity} #{today_expense.item.name}" unless today_expense.nil?
    unless weekly_expense.nil?
      output += "\nExpenses for this week: #{weekly_expense.quantity} #{weekly_expense.item.name}"
    end

    output
  end
end
