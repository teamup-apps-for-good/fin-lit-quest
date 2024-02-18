# frozen_string_literal: true



Then('I should be on the items page') do
  expect(current_path).to eq(items_path)
end



Given('I fill in Name as {string}, Description as {string}, and Value as {string}') do |string, string2, string3|
  fill_in 'Name', with: string
  fill_in 'Description', with: string2
  fill_in 'Value', with: string3
end
