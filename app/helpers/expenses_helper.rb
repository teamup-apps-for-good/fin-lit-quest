# frozen_string_literal: true

# Rendering the items in the expenses
module ExpensesHelper
  def self.display_today_expense_for_character(character)
    return 'Character details incomplete or not found.' unless character.present?

    today_expense = Expense.today_expense(character.day)
    if today_expense
      "Expenses for today: #{today_expense.quantity} #{today_expense.item.name}"
    else
      ''
    end
  end

  def self.display_this_week_expense_for_character(character)
    return 'Character details incomplete or not found.' unless character.present?

    weekly_expense = Expense.this_week_expense(character.day)
    if weekly_expense
      "Expenses for this week: #{weekly_expense.quantity} #{weekly_expense.item.name}"
    else
      ''
    end
  end
end
