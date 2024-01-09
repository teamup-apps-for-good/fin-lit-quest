Given('the following characters exist:') do |characters_table|
  # table is a Cucumber::MultilineArgument::DataTable
  characters_table.hashes.each do |character|
    Character.create character
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

Then('{string}\'s inventory slots should be {string}') do |string, string2|
  expect(page).to have_content(string2)
end

Then('I should see a balance of {string}') do |string|
  expect(page).to have_content(string)
end
