# frozen_string_literal: true



Then('I should be on the inventories page') do
  expect(current_path).to eq(inventories_path)
end

Then('I should not see {string}') do |string|
  expect(page).to have_no_content(string)
end





When('I select {string} from the {string} dropdown') do |option_name, element_name|
  select option_name, from: element_name
end

When('I fill in {string} with {string}') do |element_name, value|
  fill_in element_name, with: value
end
