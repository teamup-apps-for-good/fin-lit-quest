# frozen_string_literal: true

Then('I should see the {string} is {string}') do |field, value|
  expect(page).to have_content("#{field}: #{value}")
end







