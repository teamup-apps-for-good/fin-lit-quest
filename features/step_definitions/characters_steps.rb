









Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

When('I click on {string}') do |string|
  click_on(string)
end

Then('I should be on the {string} page') do |string|
  case string
  when 'Non-players'
    expect(current_path).to eq(nonplayers_path)
  end
end



Then('{string}\'s inventory slots should be {string}') do |_string, string2|
  expect(page).to have_content(string2)
end

Then('I should see a balance of {string}') do |string|
  expect(page).to have_content(string)
end
