# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

items = [{ name: 'fish', description: 'still floppin\' around, fresh from the ocean', value: 3 },
         { name: 'wheat', description: 'grainy, fresh from the field', value: 1 },
         { name: 'apple', description: 'crunchy, fresh from the tree', value: 2 },
         { name: 'orange', description: 'juicy, fresh from the tree', value: 2 },
         { name: 'potato', description: 'starchy, fresh from the ground', value: 1 },
         { name: 'grapes', description: 'sweet, fresh from the vine', value: 2 },
         { name: 'bread', description: 'yummy, fresh from the oven', value: 2 },
         { name: 'honey', description: 'golden, fresh from the bee hives', value: 15 },
         { name: 'bandages', description: 'patchy jobs for small injuries, fresh from the pharmacy', value: 8 },
         { name: 'book', description: 'consume for more brain cells, fresh from the printing press', value: 12 },
         { name: 'coat', description: 'warm and cozy, fresh from the tailor', value: 30 },
         { name: 'boots', description: 'sturdy and waterproof, fresh from the cobbler', value: 25 },
         { name: 'map', description: 'detailed and reliable, fresh from the cartographer', value: 15 },
         { name: 'compass', description: 'accurate and dependable, fresh from the craftsman', value: 20 },
         { name: 'canteen', description: 'for carrying water or other beverages, fresh from the craftsman', value: 8 },
         { name: 'bed roll', description: 'comfy and portable, fresh from the craftsman', value: 20 },
         { name: 'rocket ticket', description: 'one way trip to a bigger and better planet, fresh from the printer',
           value: 1000 }]

items.each do |item|
  Item.find_or_create_by!(item)
end

players = [{ name: "Stella", occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1 }]

npcs = [{ name: "Ritchey", occupation: :merchant, inventory_slots: 5, balance: 0, personality: :enthusiastic,
          dialogue_content: "Gather your required materials for your weekly expenses! Failure to do so may put you in danger.",
          item_to_offer: "fish",  quantity_to_offer: 2, item_to_accept: "wheat", quantity_to_accept: 5, current_level: 1},
        { name: "Lightfoot", occupation: :comedian, inventory_slots: 5, balance: 0, personality: :dad,
          dialogue_content: "I remember a time when I didn't gather enough materials for a day. It was a tough night, I tell you.",
          item_to_offer: "apple", quantity_to_offer: 2, item_to_accept: "orange", quantity_to_accept: 2, current_level: 1 },
        { name: "Harry", occupation: :wizard, inventory_slots: 5, balance: 50, personality: :skilled,
          dialogue_content: "I'm Harry",
          item_to_offer: "bandages", quantity_to_offer: 1, item_to_accept: "apple", quantity_to_accept: 2, current_level: 2 },
        { name: "Hermione", occupation: :witch, inventory_slots: 5, balance: 30, personality: :knowledgeable,
          dialogue_content: "hello",
          item_to_offer: "coat", quantity_to_offer: 2, item_to_accept: "book", quantity_to_accept: 3, current_level: 2 },
        { name: "Ron", occupation: :wizard, inventory_slots: 2, balance: 10, personality: :goofy,
          dialogue_content: "I <3 Hermione",
          item_to_offer: "bed roll", quantity_to_offer: 1, item_to_accept: "bread", quantity_to_accept: 3, current_level: 2 }
]

players.each { |player| Player.find_or_create_by!(player) }
npcs.each do |t|
  item_to_offer = Item.find_by name: t[:item_to_offer]
  item_to_accept = Item.find_by name: t[:item_to_accept]
  t[:item_to_offer] = item_to_offer
  t[:item_to_accept] = item_to_accept
  Nonplayer.create_or_find_by!(t)
end

inventories = [{ item: 'fish', character_id: 'Ritchey', quantity: 13 },
               { item: 'wheat', character_id: 'Stella', quantity: 12 },
               { item: 'apple', character_id: 'Stella', quantity: 5 },
               { item: 'orange', character_id: 'Ritchey', quantity: 10 },
               { item: 'potato', character_id: 'Ritchey', quantity: 9 },
               { item: 'grapes', character_id: 'Lightfoot', quantity: 8 },
               { item: 'bread', character_id: 'Lightfoot', quantity: 7 },
               { item: 'honey', character_id: 'Lightfoot', quantity: 5 },
               { item: 'bandages', character_id: 'Stella', quantity: 6 },
               { item: 'book', character_id: 'Stella', quantity: 5 },
               { item: 'coat', character_id: 'Lightfoot', quantity: 2 },
               { item: 'boots', character_id: 'Ritchey', quantity: 2 },
               { item: 'map', character_id: 'Ritchey', quantity: 3 },
               { item: 'compass', character_id: 'Lightfoot', quantity: 2 },
               { item: 'canteen', character_id: 'Stella', quantity: 4 },
               { item: 'potato', character_id: 'Harry', quantity: 9 },
               { item: 'grapes', character_id: 'Harry', quantity: 8 },
               { item: 'bread', character_id: 'Harry', quantity: 7 },
               { item: 'honey', character_id: 'Harry', quantity: 5 },
               { item: 'bandages', character_id: 'Harry', quantity: 6 },
               { item: 'book', character_id: 'Hermione', quantity: 5 },
               { item: 'coat', character_id: 'Hermione', quantity: 2 },
               { item: 'boots', character_id: 'Hermione', quantity: 2 },
               { item: 'map', character_id: 'Hermione', quantity: 3 },
               { item: 'compass', character_id: 'Hermione', quantity: 2 },
               { item: 'bed roll', character_id: 'Ron', quantity: 4 },
               { item: 'bread', character_id: 'Ron', quantity: 1 }]

inventories.each do |inventory|
  character = Character.find_by(name: inventory[:character_id])
  inventory[:character] = character

  item = Item.find_by(name: inventory[:item])
  inventory[:item] = item

  Inventory.find_or_create_by!(inventory) # Currently prevents duplicate items in inventory
end

shoppinglists = [{ item: 'apple', level: 1, quantity: 2 },
                 { item: 'orange', level: 1, quantity: 2 },
                 { item: 'wheat', level: 1, quantity: 1 },
                 { item: 'fish', level: 1, quantity: 2 },
                 { item: 'bread', level: 1, quantity: 1 },
                 { item: 'apple', level: 2, quantity: 5 },
                 { item: 'orange', level: 2, quantity: 3 },
                 { item: 'bread', level: 2, quantity: 6 },
                 { item: 'boots', level: 2, quantity: 1 },
                 { item: 'map', level: 2, quantity: 1 }]

shoppinglists.each do |shoppinglist|
  item = Item.find_by(name: shoppinglist[:item])
  shoppinglist[:item] = item

  ShoppingList.find_or_create_by!(shoppinglist)
end

preferences = [{ occupation: 'merchant', item:'map', multiplier: 2, description: 'Grinds wheat into flour and bakes handbaked bread.'}]

preferences.each do |preference|
  item = Item.find_by(name: preference[:item])
  preference[:item] = item

  Preference.find_or_create_by!(preference)
end

expenses = [{ frequency: 'day', number: 1, item: 'apple', quantity: 1 },
            { frequency: 'day', number: 2, item: 'wheat', quantity: 1 },
            { frequency: 'day', number: 3, item: 'fish', quantity: 1 },
            { frequency: 'day', number: 4, item: 'orange', quantity: 1 },
            { frequency: 'day', number: 5, item: 'potato', quantity: 1 },
            { frequency: 'day', number: 6, item: 'grapes', quantity: 1 },
            { frequency: 'day', number: 7, item: 'bread', quantity: 1 },
            { frequency: 'week', number: 1, item: 'bread', quantity: 1 },
            { frequency: 'week', number: 2, item: 'orange', quantity: 1 },
            { frequency: 'week', number: 3, item: 'grapes', quantity: 1 },
            { frequency: 'week', number: 4, item: 'potato', quantity: 1 }]

expenses.each do |expense|
  item = Item.find_by(name: expense[:item])
  expense[:item] = item

  Expense.find_or_create_by!(expense)
end
