class Nonplayer < ApplicationRecord
  belongs_to :character
  has_one :dialogue
end
