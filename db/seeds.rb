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
          dialogue_content: "hello" },
        { name: "Lightfoot", occupation: :comedian, inventory_slots: 5, balance: 0, personality: :dad,
          dialogue_content: "goodbye" }]

players.each { |player| Player.find_or_create_by!(player) }
npcs.each { |npc| Nonplayer.find_or_create_by!(npc) }

inventories = [{ item: 'fish', owner_id: 'Ritchey', quantity: 13 },
               { item: 'wheat', owner_id: 'Stella', quantity: 12 },
               { item: 'apple', owner_id: 'Stella', quantity: 5 },
               { item: 'orange', owner_id: 'Ritchey', quantity: 10 },
               { item: 'potato', owner_id: 'Ritchey', quantity: 9 },
               { item: 'grapes', owner_id: 'Lightfoot', quantity: 8 },
               { item: 'bread', owner_id: 'Lightfoot', quantity: 7 },
               { item: 'honey', owner_id: 'Lightfoot', quantity: 5 },
               { item: 'bandages', owner_id: 'Stella', quantity: 6 },
               { item: 'book', owner_id: 'Stella', quantity: 5 },
               { item: 'coat', owner_id: 'Lightfoot', quantity: 2 },
               { item: 'boots', owner_id: 'Ritchey', quantity: 2 },
               { item: 'map', owner_id: 'Ritchey', quantity: 3 },
               { item: 'compass', owner_id: 'Lightfoot', quantity: 2 },
               { item: 'canteen', owner_id: 'Stella', quantity: 4 }]

inventories.each do |inventory|
    character = Character.find_by(name: inventory[:owner_id])
    if character
        character_id = character.id
        inventory[:owner_id] = character_id
    else
        return # TODO: error logic
    end

    item = Item.find_by(name: inventory[:item])
    if item
        item_id = item.id
        inventory[:item_id] = item_id
    else
        return # TODO: error logic
    end

    if character && item
        Inventory.find_or_create_by!(inventory) # Currently prevents duplicate items in inventory
    else
        return # TODO: error logic
    end
end
