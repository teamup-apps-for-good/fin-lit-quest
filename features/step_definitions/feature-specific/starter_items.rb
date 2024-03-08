# frozen_string_literal: true

Then('{string} should have {string} {string} in their inventory') do |character, _qty, item|
  inventory = Inventory.find_by(item: Item.find_by(name: item), character: Character.find_by(name: character))
  expect(inventory).not_to be_nil
end

Then('{string}\'s inventory should be empty') do |character|
  inventory = Inventory.find_by(character: Character.find_by(name: character))
  expect(inventory).to be_nil
end
