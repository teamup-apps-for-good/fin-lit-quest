# frozen_string_literal: true

# character model
class Character < ApplicationRecord
  has_many :inventories
  has_many :items, through: :inventories, dependent: :destroy
end
