# frozen_string_literal: true

Given('the following players exist:') do |players|
  players.hashes.each do |player|
    Player.create!(player)
  end
end

Given('the following non-players exist:') do |nonplayers|
  nonplayers.hashes.each do |nonplayer|
    # cannot use symbols to access the hash here for setting
    item = Item.find_by(name: nonplayer['item_to_accept'])
    nonplayer['item_to_accept'] = item
    item = Item.find_by(name: nonplayer['item_to_offer'])
    nonplayer['item_to_offer'] = item
    Nonplayer.create!(nonplayer)
  end
end

Given('the following items exist:') do |items|
  items.hashes.each do |item|
    Item.create!(item)
  end
end

Given('I am on the character page') do
  visit characters_path
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

When('I click on {string}') do |string|
  click_on(string)
end

Then('I should be on the {string} page') do |string|
  case string
  when 'Non-players'
    expect(current_path).to eq(nonplayers_path)
  end
end

Given('I am on the {string} page for {string}') do |string, string2|
  case string
  when 'Player'
    visit player_path(Player.find_by(name: string2))
  when 'Non-player'
    visit nonplayer_path(Nonplayer.find_by(name: string2))
  end
end

Then('{string}\'s inventory slots should be {string}') do |_string, string2|
  expect(page).to have_content(string2)
end

Then('I should see a balance of {string}') do |string|
  expect(page).to have_content(string)
end
