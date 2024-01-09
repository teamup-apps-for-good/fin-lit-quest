# frozen_string_literal: true

# Model for the Inventory table.
class Inventory < ApplicationRecord
  belongs_to :owner, class_name: 'Character', foreign_key: 'owner_id'
end
