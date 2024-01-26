# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShoppingList, type: :model do
  describe 'item_obtained' do
    before(:each) do
      ShoppingList.destroy_all
      Item.destroy_all
      Character.destroy_all
      Inventory.destroy_all

      Item.create(name: 'apple',
                  description: 'crunchy, fresh from the tree',
                  value: 2)

      Item.create(name: 'orange',
                  description: 'tangy, fresh from the tree',
                  value: 2)

      Item.create(name: 'wheat',
                  description: 'grainy, fresh from the field',
                  value: 1)

      ShoppingList.create(item: Item.find_by(name: 'apple'),
                          level: 1,
                          quantity: 2)

      ShoppingList.create(item: Item.find_by(name: 'orange'),
                          level: 1,
                          quantity: 2)

      ShoppingList.create(item: Item.find_by(name: 'wheat'),
                          level: 1,
                          quantity: 5)

      Player.create(name: 'Stella',
                    occupation: :farmer,
                    inventory_slots: 5,
                    balance: 0,
                    current_level: 1)

      Inventory.create(item: Item.find_by(name: 'apple'),
                       character: Character.find_by(name: 'Stella'),
                       quantity: 5)

      Inventory.create(item: Item.find_by(name: 'wheat'),
                       character: Character.find_by(name: 'Stella'),
                       quantity: 3)
    end

    it 'returns true if correct item and quantity is in player inventory' do
      good_item = ShoppingList.find_by(item: Item.find_by(name: 'apple'))
      expect(good_item.item_obtained(Player.find_by(name: 'Stella'))).to eq(true)
    end

    it 'returns false if item is not in player inventory' do
      no_item = ShoppingList.find_by(item: Item.find_by(name: 'orange'))
      expect(no_item.item_obtained(Player.find_by(name: 'Stella'))).to eq(false)
    end

    it 'returns false if item is in player inventory but quantity is too low' do
      not_enough_item = ShoppingList.find_by(item: Item.find_by(name: 'wheat'))
      expect(not_enough_item.item_obtained(Player.find_by(name: 'Stella'))).to eq(false)
    end
  end
end
