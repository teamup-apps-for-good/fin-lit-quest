# frozen_string_literal: true

# Player character model
class Player < Character
  validates :name, :occupation, :inventory_slots, :balance, presence: true
  validates :current_level, presence: true, numericality: { greater_than: 0 }

  validates :day, numericality: { greater_than_or_equal_to: 1, only_integer: true }, presence: true
  validates :hour, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12, only_integer: true }, presence: true
  validates :era, numericality: { greater_than_or_equal_to: 1, only_integer: true }, presence: true

  before_create :set_default_time, unless: -> { day.present? && hour.present? }

  private

  def set_default_time
    self.day ||= 1
    self.hour ||= 8
    self.era ||= 1
  end
end

