# frozen_string_literal: true

Then('I should be on the inventory page for {string}') do |name|
  expect(current_path).to eq character_inventory_path(Player.find_by(name:))
end
