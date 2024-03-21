Then('I should see the current era') do
    expected_text = "Era #{Player.current_level}"
    expect(page).to have_content(expected_text)
  end
