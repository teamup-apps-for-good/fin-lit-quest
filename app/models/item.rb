# frozen_string_literal: true

# item model
class Item < ApplicationRecord
  has_many :inventories
  has_many :characters, through: :inventories
  has_many :preferences
  validates :name, presence: true
  validates :description, presence: true
  validates :value, presence: true
end
