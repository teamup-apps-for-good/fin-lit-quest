# frozen_string_literal: true

# an items that new players start with
class StarterItem < ApplicationRecord
  belongs_to :item
  validates :item, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
end
