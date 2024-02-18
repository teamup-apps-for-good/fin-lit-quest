# frozen_string_literal: true

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

Then('I should not see {string}') do |string|
  expect(page).to have_no_content(string)
end

When('I click on {string}') do |string|
  click_on(string)
end

When('I press the {string} button') do |button_name|
  click_button button_name
end

When('I select {string} from the {string} dropdown') do |option_name, element_name|
  select option_name, from: element_name
end

