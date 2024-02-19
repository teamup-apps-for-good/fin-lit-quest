# frozen_string_literal: true

# Model for the Inventory table.
class Inventory < ApplicationRecord
  belongs_to :character
  belongs_to :item
  validates :item, presence: true
  validates :character, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.deduct_expense(character, expense)
    Inventory.find_by(character:, item: expense.item).decrement!(:quantity, expense.quantity)
  end
end
