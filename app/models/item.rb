# frozen_string_literal: true

# Model for the Item table.
class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :value, presence: true
end
