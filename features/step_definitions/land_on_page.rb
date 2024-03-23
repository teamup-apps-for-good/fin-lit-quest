# frozen_string_literal: true

Then('I should be on the Players page') do
  expect(current_path).to eq(players_path)
end

Then('I should be on the Non-players page') do
  expect(current_path).to eq(nonplayers_path)
end

Then('I should be on the items page') do
  expect(current_path).to eq(items_path)
end

Then('I should be on the inventories page') do
  expect(current_path).to eq(inventories_path)
end

Then('I should be on the counter offer page for {string}') do |name|
  character = Character.find_by(name:)
  expect(character).not_to be_nil, "Character #{name} not found"
  expect(current_path).to eq("/counter_offer/#{character.id}")
  expect(page).to have_content(name)
end

Then('I should be on the trade page for {string}') do |name|
  character = Character.find_by(name:)
  expect(character).not_to be_nil, "Character #{name} not found"
  expect(current_path).to eq("/trade/#{character.id}")
  expect(page).to have_content(name)
end

Then('I should be on the profile page for {string}') do |nonplayer|
  expect(page).to have_current_path(character_profile_path(Nonplayer.find_by(name: nonplayer)))
end

Then('I should be on the tutorial page') do
  expect(page).to have_current_path(tutorial_path(1))
end
