# frozen_string_literal: true

# a weekly allowance for all characters
class Allowance < ApplicationRecord
  belongs_to :item, optional: true
  validates :level, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }

  def self.advance_and_credit(character)
    return if character.nil?
    return unless (character.day % 7).zero?

    Allowance.where(level: character.current_level).each do |allowance|
      if allowance.item.nil?
        character.increment!(:balance, allowance.quantity)
      else
        allowance.instance_eval { update_inventory character }
      end
    end
  end

  private

  def update_inventory(character)
    inventory = Inventory.find_by(character:, item:)
    if inventory.nil?
      Inventory.create!(character:, item:, quantity:)
    else
      inventory.increment!(:quantity, quantity)
    end
  end
end
