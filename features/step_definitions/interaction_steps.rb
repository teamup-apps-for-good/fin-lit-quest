Given('the following inventory table exists:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  table.hashes.each do |inventory|
    Inventory.create inventory
  end
end

Given('the following items table exist:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  table.hashes.each do |item|
    Item.create item
  end
end

Given('I am on the {string} page') do |string|
  visit inventories_path
end

Then('I should be on the {string} page for apple') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see {string} information') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be on the {string} page for Stella') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be on the {string} page for Ritchey') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see a {string} of {string} for {string}') do |string, string2, string3|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see {string} information') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be on the {string} page for {string}') do |string, string2|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see {string} as a description for {string}') do |string, string2|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see {string} for {string}') do |string, string2|
  pending # Write code here that turns the phrase above into concrete actions
end