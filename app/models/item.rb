# frozen_string_literal: true

# item model
class Item < ApplicationRecord
  has_many :inventories
  has_many :characters, through: :inventories
end
