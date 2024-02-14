# frozen_string_literal: true

Given('I am on the home page') do
  visit root_path
end

Given('{string} is on Day {string} and Hour {string}') do |name, day, hour|
  character = Character.find_by(name: name)
  if character.present?
    character.update!(day: day.to_i, hour: hour.to_i)
    expect(character.day).to eq(day.to_i)
    expect(character.hour).to eq(hour.to_i)
  else
    raise "Character '#{name}' not found."
  end
end


Then('I should see "{string}"') do |expected_text|
  actual_content = page.text
  puts "Actual content on page: #{actual_content}"
  expect(page).to have_content(expected_text)
end

Then('{string} should be on Day {string} and Hour {string}') do |name, expected_day, expected_hour|
  character = Character.find_by(name: name)
  if character.present?
    expect(character.day).to eq(expected_day.to_i)
    expect(character.hour).to eq(expected_hour.to_i)
  else
    raise "Character '#{name}' not found."
  end
end
