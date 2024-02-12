# frozen_string_literal: true

Given('the following preference table exists:') do |preferences|
  # table is a Cucumber::MultilineArgument::DataTable
  preferences.hashes.each do |preference|
    item = Item.find_by(name: preference['item'])
    preference['item'] = item
  
    Preference.create!(preference)
  end
end
