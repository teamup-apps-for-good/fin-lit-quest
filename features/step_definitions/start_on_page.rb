# frozen_string_literal: true

Given('I am on the home page') do
  visit root_path
end

Given('I am on the town page') do
  visit town_path
end

Given('I am on the character page') do
  visit characters_path
end

Given('I am on the Player page for {string}') do |string|
  visit player_path(Player.find_by(name: string))
end

Given('I am on the Non-player page for {string}') do |string|
  visit nonplayer_path(Nonplayer.find_by(name: string))
end

Given('I am on the new nonplayer character page') do
  visit new_nonplayer_path
end

Given('I am on the profile page for {string}') do |nonplayer|
  visit character_profile_path(Nonplayer.find_by(name: nonplayer))
end

Given('I am on the items page') do
  visit items_path
end

Given('I am on the item page for {string}') do |string|
  visit item_path(Item.find_by(name: string))
end

Given('I am on the inventories page') do
  visit inventories_path
end

Given('I am on the inventory page for {string}') do |character|
  visit character_inventory_path(Character.find_by(name: character))
end

Given('I am on the inventory page for {string} that is owned by {string}') do |string, string2|
  visit inventory_path(Inventory.find_by(item: Item.find_by(name: string),
                                         character: Character.find_by(name: string2)))
end

Given('I am on the inventory edit page for {string} that is owned by {string}') do |string, string2|
  visit edit_inventory_path(Inventory.find_by(item: Item.find_by(name: string),
                                              character: Character.find_by(name: string2)))
end

Given('I am on the new inventory entry page') do
  visit new_inventory_path
end

Given('I am on the trade page for {string}') do |nonplayer|
  visit trade_path(Nonplayer.find_by(name: nonplayer))
end

Given('I am on the counter offer page for {string}') do |name|
  character = Character.find_by(name:)
  expect(character).not_to be_nil, "Character #{name} not found"
  visit("/counter_offer/#{character.id}")
  expect(page).to have_content(name)
end

Given('I am on the shopping list page') do
  visit player_shopping_list_path
end

When('I visit the home page') do
  visit root_path
end

Given('I am on the tutorial page') do
  pending # Write code here that turns the phrase above into concrete actions
end