# frozen_string_literal: true

Then('{string} should own {string} of {string}') do |string, string2, string3|
  visit character_inventory_path(Character.find_by(name: string))
  inventory = Inventory.find_by(item: Item.find_by(name: string3), character: Character.find_by(name: string))
  within "##{dom_id(inventory)}" do
    expect(page).to have_content(/Quantity: #{Regexp.escape(string2)}/m)
  end
end

Given(/^"([^"]*)" has "([^"]*)" of "([^"]*)"$/) do |character_name, quantity, item_name|
  character = Character.find_by(name: character_name)
  item = Item.find_by(name: item_name)
  InventoryService.set_inventory(character, item.id, quantity.to_i)
end
