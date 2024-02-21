# frozen_string_literal: true

# Daily and weekly expenses for players that incurs in the progression of time
class Expense < ApplicationRecord
  belongs_to :item
  validates :number, numericality: { only_integer: true, greater_than: 0 }
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :item, :number, :frequency, :quantity, presence: true
  validate :validate_max_number_based_on_day_or_week

  def self.today_expense(number)
    number = ((number - 1) % 7) + 1
    Expense.find_by(frequency: 'day', number:)
  end

  def self.this_week_expense(number)
    number = ((number - 1) / 7) + 1
    Expense.find_by(frequency: 'week', number:)
  end

  def self.advance_and_deduct?(character)
    return false if character.nil?

    today_expense = Expense.today_expense(character.day)
    this_week_expense = Expense.this_week_expense(character.day)
    if Inventory.satisfy_expense?(character, today_expense, this_week_expense)
      Inventory.deduct_expense(character, today_expense) if today_expense.present?
      Inventory.deduct_expense(character, this_week_expense) if this_week_expense.present?
      true
    else
      false
    end
  end

  private

  def validate_max_number_based_on_day_or_week
    if frequency == 'day' && number > 7
      errors.add(:number, 'cannot be greater than 7 for daily frequency')
    elsif frequency == 'week' && number > 4
      errors.add(:number, 'cannot be greater than 4 for weekly frequency')
    end
  end
end
