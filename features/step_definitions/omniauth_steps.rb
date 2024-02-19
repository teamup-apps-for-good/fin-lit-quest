Given('I am not logged in') do
  visit logout_path
  visit root_path
  expect(page).to have_current_path welcome_path
end

Then('I should be on the login page') do
  expect(page).to have_current_path welcome_path
end

Given('I am logged in as {string}') do |name|
  OmniAuth.config.test_mode = true
  Capybara.default_host = 'https://fin-lit-quest-65cfa09cddc8.herokuapp.com/'

  OmniAuth.config.add_mock(:google, {
    :uid => '`1234`',
    :info => {
      :name => 'Stella'
    }
  })

  visit welcome_path
  click_on "Sign in with Googl"
  expect(page).to have_current_path root_path
end

Given('I am on the login page') do
  visit welcome_path
  expect(page).to have_current_path welcome_path
end

Then('I should be on the home page') do
  expect(page).to have_current_path root_path
end
