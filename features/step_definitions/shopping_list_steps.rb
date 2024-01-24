# frozen_string_literal: true

Given('the following shopping list table exists:') do |shoppinglists|
  # table is a Cucumber::MultilineArgument::DataTable
  shoppinglists.hashes.each do |shoppinglist_entry|
    item = Item.find_by(name: shoppinglist_entry['item'])
    shoppinglist_entry['item'] = item
    ShoppingList.create(shoppinglist_entry)
  end
end

Given('I am on the shopping list page') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see {int} apple:') do |_int|
  # Then('I should see {float} apple:') do |float|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see {int} orange:') do |_int|
  # Then('I should see {float} orange:') do |float|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see {int} wheat:') do |_int|
  # Then('I should see {float} wheat:') do |float|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see {int} fish:') do |_int|
  # Then('I should see {float} fish:') do |float|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see {int} bread:') do |_int|
  # Then('I should see {float} bread:') do |float|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see orange marked as complete') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see apple marked as complete') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see fish marked as complete') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see bread marked as incomplete') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see wheat marked as incomplete') do
  pending # Write code here that turns the phrase above into concrete actions
end
