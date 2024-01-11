# frozen_string_literal: true

Given('I am on the items page') do
  visit items_path
end

Then('I should be on the items page') do
  expect(current_path).to eq(items_path)
end

Given('I am on the item page for {string}') do |string|
  visit item_path(Item.find_by(name: string))
end

Given('I fill in Name as {string}, Description as {string}, and Value as {string}') do |string, string2, string3|
  fill_in 'Name', with: string
  fill_in 'Description', with: string2
  fill_in 'Value', with: string3
end
