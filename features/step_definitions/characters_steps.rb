Given('the following characters exist:') do |characters_table|
  # table is a Cucumber::MultilineArgument::DataTable
  characters_table.hashes.each do |character|
    Character.create character
  end
end

Given('I am on the character page') do
  visit(:characters)
end

Then('I should see {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click on {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be on the {string} page') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I am on the {string} page for {string}') do |string, string2|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('{string}\'s inventory slots should be {string}') do |string, string2|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see a balance of {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end
