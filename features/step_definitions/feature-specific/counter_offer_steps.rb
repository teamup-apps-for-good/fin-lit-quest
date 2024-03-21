# frozen_string_literal: true

When('I fill in the number of items that I give with {string}') do |number|
  fill_in 'quantity_i_give', with: number
end

When('I fill in the number of items that I want with {string}') do |number|
  fill_in 'quantity_i_want', with: number
end

Then('I should see the player owns {string} of {string}') do |quantity, item|
  item_id = "player_inventory_#{item.downcase}"
  inventory_item = find("##{item_id}")
  expect(inventory_item).to have_content("#{item.capitalize} : #{quantity}")
end

Then('I should see the NPC owns {string} of {string}') do |quantity, item|
  item_id = "npc_inventory_#{item.downcase}"
  inventory_item = find("##{item_id}")
  expect(inventory_item).to have_content("#{item.capitalize} : #{quantity}")
end
