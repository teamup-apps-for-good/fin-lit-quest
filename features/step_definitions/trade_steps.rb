# frozen_string_literal: true

Then('I should see a notice of {string}') do |string|
  expect(page).to have_content(string)
end

Then('{string} should own {string} of {string}') do |string, string2, string3|
  visit character_inventory_path(Character.find_by(name: string))
  expect(page).to have_content(/\nName: #{Regexp.escape(string3)}\s\n*.*\nQuantity: #{Regexp.escape(string2)}/m)
end
