# frozen_string_literal: true

# Model for the Inventory table.
class Inventory < ApplicationRecord
  belongs_to :character
  belongs_to :item
end
