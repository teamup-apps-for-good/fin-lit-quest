# frozen_string_literal: true

# player character model
class Player < Character
  validates :name, :occupation, :inventory_slots, :balance, :current_level, presence: true
end
