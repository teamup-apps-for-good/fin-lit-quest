# frozen_string_literal: true

Given('I am on the counter offer page for {string}') do |item_name|
  # Assuming you have a path helper defined for this route
  visit counter_offer_path(item_name)
end

When('I choose {string} in {string} dropdown') do |option, dropdown_name|
  # Here, you need to replace 'dropdown_id' with the actual id or name of your dropdown
  select option, from: dropdown_name
end

When('I fill in the number of items that I give with {string}') do |number|
  # Replace 'input_field_id' with the actual id or name of your input field
  fill_in 'counter_offer_quantity_i_give', with: number
end

When('I fill in the number of items that I want with {string}') do |number|
  # Similarly, replace 'input_field_id' with the id or name of the input field for receiving items
  fill_in 'counter_offer_quantity_i_want', with: number
end

When('I press the {string} button') do |button_name|
  click_button button_name
end

Then(/^I should be on the counter offer page for "(.+)"$/) do |name|
  expect(current_path).to eq("/counter_offer/#{name}")
end

Then('I should see a notice of {string}') do |notice_message|
  expect(page).to have_content(notice_message)
end

Then('I should see the player owns {string} of {string}') do |quantity, item|
  # Replace 'css_selector' with the actual selector that identifies where this information is displayed
  within 'css_selector' do
    expect(page).to have_content("#{item}: #{quantity}")
  end
end

Then('I should see {string} owns {string} of {string}') do |player_name, quantity, item|
  # Similar to above, use the appropriate selector for the non-player's inventory display
  within 'css_selector' do
    expect(page).to have_content("#{player_name} owns #{quantity} of #{item}")
  end
end
