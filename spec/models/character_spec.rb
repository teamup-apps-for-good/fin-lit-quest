# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Character, type: :model do
  describe 'associations' do
    before do
      apple = Item.create!(name: 'apple', description: 'crunchy, fresh from the tree', value: 2)
      orange = Item.create!(name: 'orange', description: 'test description', value: 5)
      @character = Player.create!(name: 'Stella', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1)
      Inventory.create!(item: apple, character: @character, quantity: 1)
      Inventory.create!(item: orange, character: @character, quantity: 1)
    end

    it 'has an association with inventory' do
      expect(@character.inventories).not_to be_nil
    end
    it 'has an association with items' do
      expect(@character.items).not_to be_nil
    end
  end
end
