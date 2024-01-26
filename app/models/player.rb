# frozen_string_literal: true

# player character model
class Player < Character
  validates :name, :occupation, :inventory_slots, :balance, presence: true
  validates :current_level, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
