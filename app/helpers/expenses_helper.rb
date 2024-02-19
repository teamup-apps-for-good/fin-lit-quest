# frozen_string_literal: true

# Rendering the items in the expenses
module ExpensesHelper
  def self.display_current_expense_for_character(character)
    return 'Character details incomplete or not found.' unless character.present?

    expense = Expense.day(character.day)
    if expense
      "Expenses for today: #{expense.quantity} #{expense.item.name}"
    else
      ''
    end
  end
end
