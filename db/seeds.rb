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
           value: 1000
         }
        ]


items.each do |item|
  Item.find_or_create_by!(item)
end
