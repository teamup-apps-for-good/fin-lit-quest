# frozen_string_literal: true

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

Then('I should see the {string} is {string}') do |field, value|
  expect(page).to have_content(/#{field}: #{value}/i)
end

Then('I should see the NPC {string} owns {string} of {string}') do |npc, value, field|
  within("##{npc}_inventory") do
    expect(page).to have_content(/#{Regexp.escape("#{field} : #{value}")}/i)
  end
end

Then('I should not see {string}') do |string|
  expect(page).to have_no_content(string)
end

When('I click on {string}') do |string|
  if string == 'Sign in with Google'
    OmniAuth.config.test_mode = true
    Capybara.default_host = 'https://fin-lit-quest-65cfa09cddc8.herokuapp.com/'

    OmniAuth.config.add_mock(:google_oauth2, {
                               uid: '1234',
                               info: {
                                 name: 'Stella',
                                 email: 'test@test.com'
                               }
                             })
    click_on(string)
    OmniAuth.config.test_mode = false
  else
    click_on(string)
  end
end

When('I press the {string} button') do |button_name|
  click_button button_name
end

When('I select {string} from the {string} dropdown') do |option_name, element_name|
  select option_name, from: element_name
end

When('I select {string} in {string} dropdown') do |option_name, element_name|
  select option_name, from: element_name
end

When('I fill in {string} with {string}') do |element_name, value|
  fill_in element_name, with: value
end

Then('I should see a notice of {string}') do |string|
  expect(page).to have_content(string)
end

Then('I should see {string} in {string} dropdown') do |item_name, element_name|
  expect(page).to have_select(element_name, selected: item_name)
end

Then('I should see {string} in {string} field') do |value, element_name|
  actual_value = find_field(element_name).value
  expect(actual_value).to eq(value)
end
