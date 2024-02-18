# frozen_string_literal: true

When('{string} is given {string} {string}') do |character_name, amount, item_name|
  Inventory.create(item: Item.find_by(name: item_name),
                   character: Character.find_by(name: character_name),
                   quantity: amount)
end
