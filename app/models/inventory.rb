# frozen_string_literal: true

# Model for the Inventory table.
class Inventory < ApplicationRecord
  belongs_to :owner, class_name: 'Character', foreign_key: 'owner_id'
  validates :item, presence: true
  validates :owner_id, presence: true
  validates :quantity, presence: true
end
