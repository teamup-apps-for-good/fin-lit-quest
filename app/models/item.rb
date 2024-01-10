# frozen_string_literal: true

class Item < ApplicationRecord
    validates :name, presence: true
    validates :description, presence: true
    validates :value, presence: true
end
