# frozen_string_literal: true

# Nonplayers model
class Nonplayer < ApplicationRecord
  belongs_to :character
  has_one :dialogue
end
