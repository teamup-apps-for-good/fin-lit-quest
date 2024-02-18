# frozen_string_literal: true

Then('for {string} I should see the {string} is {string}') do |item_name, field_name, value|
  # looks for <p> with the item name, and then go up to the div
  item_div = page.find('p', text: item_name).find(:xpath, '..')
  # checks the div to contain the correct information
  expect(item_div).to have_text("#{field_name}: #{value}")
end

Given('I fill in Name as {string}, Description as {string}, and Value as {string}') do |string, string2, string3|
  fill_in 'Name', with: string
  fill_in 'Description', with: string2
  fill_in 'Value', with: string3
end
