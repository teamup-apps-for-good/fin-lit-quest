# frozen_string_literal: true

Then('I should see the {string} is {string}') do |field, value|
  expect(page).to have_content("#{field}: #{value}")
end





Then('I should be on the profile page for {string}') do |nonplayer|
  expect(page).to have_current_path(character_profile_path(Nonplayer.find_by(name: nonplayer)))
end

