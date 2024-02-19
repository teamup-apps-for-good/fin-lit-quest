# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShoppingList, type: :model do
  describe 'item_obtained' do
    before do
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
                    current_level: 1,
                    email: 'test@test.com',
                    provider: 'google-oauth2',
                    uid: '1234')

      Inventory.create(item: Item.find_by(name: 'apple'),
                       character: Character.find_by(name: 'Stella'),
                       quantity: 5)

      Inventory.create(item: Item.find_by(name: 'wheat'),
                       character: Character.find_by(name: 'Stella'),
                       quantity: 3)

      @stella = Player.find_by(name: 'Stella')
      @good_item = ShoppingList.find_by(item: Item.find_by(name: 'apple'))
      @no_item = ShoppingList.find_by(item: Item.find_by(name: 'orange'))
      @not_enough_item = ShoppingList.find_by(item: Item.find_by(name: 'wheat'))
    end

    it 'returns true if correct item and quantity is in player inventory' do
      expect(@good_item.item_obtained(@stella)).to eq(true)
    end

    it 'returns false if item is not in player inventory' do
      expect(@no_item.item_obtained(@stella)).to eq(false)
    end

    it 'returns false if item is in player inventory but quantity is too low' do
      expect(@not_enough_item.item_obtained(@stella)).to eq(false)
    end
  end
end
