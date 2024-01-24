# frozen_string_literal: true

Given('the following inventory table exists:') do |inventories|
  inventories.hashes.each do |inventory_entry|
    item = Item.find_by(name: inventory_entry['item'])
    inventory_entry['item'] = item
    character = Character.find_by(name: inventory_entry['character'])
    inventory_entry['character'] = character
    Inventory.create(inventory_entry)
  end
end

Given('I am on the inventories page') do
  visit inventories_path
end

Then('I should be on the inventories page') do
  expect(current_path).to eq(inventories_path)
end

Then('I should not see {string}') do |string|
  expect(page).to have_no_content(string)
end

Given('I am on the inventory page for {string} that is owned by {string}') do |string, string2|
  visit inventory_path(Inventory.find_by(item: Item.find_by(name: string),
                                         character: Character.find_by(name: string2)))
end

Given('I am on the new inventory entry page') do
  visit new_inventory_path
end

When('I select {string} from the {string} dropdown') do |option_name, element_name|
  select option_name, :from => element_name
end

When('I fill in {string} with {string}') do |element_name, value|
  fill_in element_name, :with => value
end
