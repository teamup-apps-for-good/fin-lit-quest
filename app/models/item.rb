# frozen_string_literal: true

class Item < ApplicationRecord
  has_many :inventories
  has_many :characters, :through => :inventories
end
