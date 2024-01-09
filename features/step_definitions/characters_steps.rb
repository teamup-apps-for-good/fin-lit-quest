Given('the following characters exist:') do |characters_table|
  # table is a Cucumber::MultilineArgument::DataTable
  characters_table.hashes.each do |character|
    Character.create character
  end
end

Given('the following player characters exist:') do |players_table|
  # table is a Cucumber::MultilineArgument::DataTable
  players_table.hashes.each do |player|
    character = Character.find(player['character'])

    Player.create!(
      character:,
      current_level: player['current_level'].to_i
    )
  end
end

Given('the following non-player characters exist:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I am on the characters page') do
  visit()
end

Then('I should see {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I am on the character interaction page') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click on {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be on the {string} page') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click on the character {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I am on the {string} page for {string}') do |string, string2|
  pending # Write code here that turns the phrase above into concrete actions
end