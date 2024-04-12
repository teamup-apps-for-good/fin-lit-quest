# frozen_string_literal: true

Given('{string} has a balance of {string}') do |character_name, balance|
  character = Character.find_by(name: character_name)
  character.update(balance: balance.to_i)
end
When(/^I select "([^"]*)" from "([^"]*)" dropdown for "([^"]*)"$/) do |option_text, _dropdown_name, action|
  dropdown_id = case action
                when 'buying'
                  'item_i_want_id' # Updated to match the actual ID from the HTML template
                when 'selling'
                  'item_i_give_select'
                else
                  raise "Action not recognized: #{action}"
                end
  select(option_text, from: dropdown_id)
end

Then('I should see total price as {string}') do |expected_price|
  puts(find('#total_price').text)
  expect(find('#total_price').text).to eq(expected_price)
end
