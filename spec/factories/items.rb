# frozen_string_literal: true

# spec/factories/items.rb
FactoryBot.define do
  factory :item do
    name { 'Test Item' }
    description { 'This is a test item.' }
    value { 100 }
  end
end
