# frozen_string_literal: true

Given(/^I am on the counter offer page for "(.+)"$/) do |name|
  character = Character.find_by(name:)
  expect(character).not_to be_nil, "Character #{name} not found"
  visit("/counter_offer/#{character.id}")
  expect(page).to have_content(name)
end

When('I choose {string} in {string} dropdown') do |option, dropdown_label|
  dropdown_id = case dropdown_label
                when 'I give'
                  'item_i_give_id'
                when 'I want'
                  'item_i_want_id'
                else
                  raise "Unknown dropdown label: #{dropdown_label}"
                end

  select option, from: dropdown_id
end

When('I fill in the number of items that I give with {string}') do |number|
  fill_in 'quantity_i_give', with: number
end

When('I fill in the number of items that I want with {string}') do |number|
  fill_in 'quantity_i_want', with: number
end

When('I press the {string} button') do |button_name|
  click_button button_name
end

Then(/^I should be on the counter offer page for "(.+)"$/) do |name|
  character = Character.find_by(name:)
  expect(character).not_to be_nil, "Character #{name} not found"
  expect(current_path).to eq("/counter_offer/#{character.id}")
  expect(page).to have_content(name)
end

Then('I should see the player owns {string} of {string}') do |quantity, item|
  item_id = "player_inventory_#{item.downcase}"
  inventory_item = find("##{item_id}")
  expect(inventory_item).to have_content("#{item.capitalize}: #{quantity}")
end

Then('I should see the NPC {string} owns {string} of {string}') do |_npc_name, quantity, item|
  expect(page).to have_content("#{item.capitalize}: #{quantity}")
end
