# frozen_string_literal: true

# Player character model
class Player < Character
  validates :name, :occupation, :inventory_slots, :balance, :email, :uid, :provider, presence: true
  validates :current_level, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :day, numericality: { greater_than_or_equal_to: 1, only_integer: true }, presence: true
  validates :hour, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 11, only_integer: true },
                   presence: true
  validates :uid, uniqueness: { scope: :provider, allow_blank: false, message: 'must be unique per provider' }
end
