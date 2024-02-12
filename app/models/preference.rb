# frozen_string_literal: true

# Preference model definition
class Preference < ApplicationRecord
  belongs_to :item
end
