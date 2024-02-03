# frozen_string_literal: true

# spec/factories/inventories.rb
FactoryBot.define do
  factory :inventory do
    item
    character
    quantity { 10 }
  end
end
