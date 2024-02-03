# frozen_string_literal: true

Then('I should see the {string} is {string}') do |field, value|
  expect(page).to have_content("#{field}: #{value}")
end

Given('the following inventory exist:') do |inventories|
  inventories.hashes.each do |inventory_entry|
    item = Item.find_by(name: inventory_entry['item'])
    inventory_entry['item'] = item
    character = Character.find_by(name: inventory_entry['character'])
    inventory_entry['character'] = character
    Inventory.create!(inventory_entry)
  end
end

Given('I am on the town page') do
  visit town_path
end

Then('I should be on the profile page for {string}') do |nonplayer|
  expect(page).to have_current_path(character_profile_path(Nonplayer.find_by(name: nonplayer)))
end

Given('I am on the profile page for {string}') do |nonplayer|
  visit character_profile_path(Nonplayer.find_by(name: nonplayer))
end

Given('I am on the trade page for {string}') do |nonplayer|
  visit trade_path(Nonplayer.find_by(name: nonplayer))
end

Given('I am on the inventory page for {string}') do |character|
  visit character_inventory_path(Character.find_by(name: character))
end
