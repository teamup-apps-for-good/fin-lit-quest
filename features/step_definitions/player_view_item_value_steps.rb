# frozen_string_literal: true

Then('for {string} I should see the {string} is {string}') do |item_name, field_name, value|
  # looks for <p> with the item name, and then go up to the div
  item_div = page.find('p', text: item_name).find(:xpath, '..')
  # checks the div to contain the correct information
  expect(item_div).to have_text("#{field_name}: #{value}")
end
