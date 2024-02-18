# frozen_string_literal: true

Given('{string} is on Day {string} and Hour {string}') do |name, day, hour|
  character = Character.find_by(name:)
  raise "Character '#{name}' not found." unless character.present?

  character.update!(day: day.to_i, hour: hour.to_i)
  expect(character.day).to eq(day.to_i)
  expect(character.hour).to eq(hour.to_i)
end

Then('{string} should be on Day {string} and Hour {string}') do |name, expected_day, expected_hour|
  character = Character.find_by(name:)
  raise "Character '#{name}' not found." unless character.present?

  expect(character.day).to eq(expected_day.to_i)
  expect(character.hour).to eq(expected_hour.to_i)
end
