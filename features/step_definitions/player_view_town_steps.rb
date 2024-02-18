# frozen_string_literal: true

Then('I should see the {string} is {string}') do |field, value|
  expect(page).to have_content("#{field}: #{value}")
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
