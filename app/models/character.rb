# frozen_string_literal: true

class Character < ApplicationRecord
  has_many :inventories
  has_many :items, :through => :inventories, dependent: :destroy
end
