# frozen_string_literal: true

# Model for the Inventory table.
class Inventory < ApplicationRecord
  belongs_to :character
  belongs_to :item
  validates :item, presence: true
  validates :character, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.deduct_expense(player, expense)
    Inventory.find_by(character: player, item: expense.item).decrement!(:quantity, expense.quantity)
  end

  def self.satisfy_expense?(player, expense1, expense2)
    return true if expense1.nil? && expense2.nil?
    return satisfy_single_expense?(player, expense1) if expense2.nil?
    return satisfy_single_expense?(player, expense2) if expense1.nil?
    return satisfy_same_expense?(player, expense1, expense2) if expense1.item == expense2.item

    satisfy_diff_expense?(player, expense1, expense2)
  end

  def self.satisfy_single_expense?(player, expense)
    inventory = Inventory.find_by(character: player, item: expense.item)
    inventory && inventory.quantity >= expense.quantity
  end

  def self.satisfy_same_expense?(player, expense1, expense2)
    inventory = Inventory.find_by(character: player, item: expense1.item)
    inventory && inventory.quantity >= expense1.quantity + expense2.quantity
  end

  def self.satisfy_diff_expense?(player, expense1, expense2)
    inventory1 = Inventory.find_by(character: player, item: expense1.item)
    inventory2 = Inventory.find_by(character: player, item: expense2.item)

    return false unless inventory1 && inventory2

    enough_quantity1 = inventory1.quantity >= expense1.quantity
    enough_quantity2 = inventory2.quantity >= expense2.quantity

    enough_quantity1 && enough_quantity2
  end

  private_class_method :satisfy_single_expense?, :satisfy_same_expense?, :satisfy_diff_expense?
end
