# frozen_string_literal: true

Given('the following characters exist:') do |characters_table|
  # table is a Cucumber::MultilineArgument::DataTable
  characters_table.hashes.each do |character|
    Character.create character
  end
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

When('I click on {string}') do |string|
  click_on(string)
end

Then('I should be on the {string} page') do |string|
  case string.downcase
  when 'character'
    expect(current_path).to eq(character_page)
  when 'non-players'
    expect(current_path).to eq(nonplayers_path)
  else
    raise "failed to find page"
  end
end

Given('I am on the {string} page for {string}') do |string, string2|
  case string.downcase
  when 'player'
    visit player_path(Player.find_by(name: string2))
  when 'non-player'
    visit nonplayer_path(Nonplayer.find_by(name: string2))
  when 'inventory'
    visit player_inventories_path(Player.find_by(name: string2))
  else
    raise "failed to find page"
  end
end

Then('{string}\'s inventory slots should be {string}') do |_string, string2|
  expect(page).to have_content(string2)
end

Then('I should see a balance of {string}') do |string|
  expect(page).to have_content(string)
end
