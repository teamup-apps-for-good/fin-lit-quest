# frozen_string_literal: true

Then('{string} should own {string} of {string}') do |string, string2, string3|
  visit character_inventory_path(Character.find_by(name: string))
  inventory = Inventory.find_by(item: Item.find_by(name: string3), character: Character.find_by(name: string))
  within "##{dom_id(inventory)}" do
    expect(page).to have_content(/Quantity: #{Regexp.escape(string2)}/m)
  end
end

Then('I should see {string} in {string}') do |inventory_text, npc_name|
  expect(page).to have_content("#{npc_name}")
  expect(page).to have_content(inventory_text)
end