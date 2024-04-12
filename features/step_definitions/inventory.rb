# frozen_string_literal: true

Then('{string} should have {string} {string} in their inventory') do |character, qty, item|
  inventory = Inventory.find_by(item: Item.find_by(name: item), character: Character.find_by(name: character))
  if qty != '0'
    expect(inventory).not_to be_nil
    expect(inventory.quantity).to be Integer(qty)
  elsif !inventory.nil?
    expect(inventory.quantity).to be 0
  end
end

Then('{string}\'s inventory should be empty') do |character|
  inventory = Inventory.find_by(character: Character.find_by(name: character))
  expect(inventory).to be_nil
end

Then('{string}\'s inventory should not be empty') do |character|
  inventory = Inventory.find_by(character: Character.find_by(name: character))
  expect(inventory).not_to be_nil
end

Then('{string} should have {string} balance') do |character, balance|
  character = Character.find_by(name: character)
  expect(character.balance).to be Integer(balance)
end
