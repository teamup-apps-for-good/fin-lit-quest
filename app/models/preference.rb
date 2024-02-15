# frozen_string_literal: true

# Preference model definition
class Preference < ApplicationRecord
  belongs_to :item
  validates :multiplier, presence: true, numericality: { greater_than_or_equal_to: 1 }
end
