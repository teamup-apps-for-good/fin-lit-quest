# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShoppingListsController, type: :controller do
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

    Item.create(name: 'boots',
                description: 'sturdy and waterproof, fresh from the cobbler',
                value: 25)

    Item.create(name: 'map',
                description: 'detailed and reliable, fresh from the cartographer',
                value: 15)

    Item.create(name: 'fish',
                description: 'still floppin\' around, fresh from the ocean',
                value: 3)

    ShoppingList.create(item: Item.find_by(name: 'apple'),
                        level: 1,
                        quantity: 2)

    ShoppingList.create(item: Item.find_by(name: 'orange'),
                        level: 1,
                        quantity: 2)

    ShoppingList.create(item: Item.find_by(name: 'wheat'),
                        level: 1,
                        quantity: 5)

    ShoppingList.create(item: Item.find_by(name: 'boots'),
                        level: 2,
                        quantity: 2)

    ShoppingList.create(item: Item.find_by(name: 'map'),
                        level: 2,
                        quantity: 1)

    ShoppingList.create(item: Item.find_by(name: 'fish'),
                        level: 2,
                        quantity: 3)

    Character.create(name: 'Stella',
                     occupation: :farmer,
                     inventory_slots: 5,
                     balance: 0,
                     current_level: 1)

    Character.create(name: 'Victor',
                     occupation: :fisherman,
                     inventory_slots: 5,
                     balance: 0,
                     current_level: 2)

    # happy
    Inventory.create(item: Item.find_by('apple'),
                     character: Character.find_by('Stella'),
                     quantity: 2)

    # not enough
    Inventory.create(item: Item.find_by('orange'),
                     character: Character.find_by('Stella'),
                     quantity: 1)

    # not in list of current level
    Inventory.create(item: Item.find_by('boots'),
                     character: Character.find_by('Stella'),
                     quantity: 2)

    # happy
    Inventory.create(item: Item.find_by('map'),
                     character: Character.find_by('Victor'),
                     quantity: 1)

    # not in list of current level
    Inventory.create(item: Item.find_by('orange'),
                     character: Character.find_by('Victor'),
                     quantity: 2)

    # not enough
    Inventory.create(item: Item.find_by('boots'),
                     character: Character.find_by('Victor'),
                     quantity: 1)
  end
end
