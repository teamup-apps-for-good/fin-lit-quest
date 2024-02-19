# frozen_string_literal: true

# Daily and weekly expenses for players that incurs in the progression of time
class Expense < ApplicationRecord
  belongs_to :item
  validates :number, numericality: { only_integer: true, greater_than: 0 }
  validates :item, :number, :frequency, :quantity, presence: true
  validate :validate_max_number_based_on_day_or_week

  def self.today_expense(number)
    number = ((number - 1) % 7) + 1
    Expense.find_by(frequency: 'day', number:)
  end

  def satisfy?(player)
    return false if player.nil?

    inventory_entry = Inventory.find_by(item:, character: player)
    return false if inventory_entry.nil?

    Inventory.find_by(item:, character: player).quantity >= quantity
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
