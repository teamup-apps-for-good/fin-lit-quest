# frozen_string_literal: true

Given('the following shopping list table exists:') do |shoppinglists|
  # table is a Cucumber::MultilineArgument::DataTable
  shoppinglists.hashes.each do |shoppinglist_entry|
    item = Item.find_by(name: shoppinglist_entry['item'])
    shoppinglist_entry['item'] = item
    ShoppingList.create!(shoppinglist_entry)
  end
end

Given('I am on the shopping list page') do
  visit player_shopping_list_path
end

Then('I should see {string} {string} from world {string}:') do |quantity, item, world|
  shopping_list = ShoppingList.find_by(item: Item.find_by(name: item), level: world.to_i)
  within "##{dom_id(shopping_list)}" do
    expect(page).to have_content("#{quantity} x #{item}")
  end
end

Then('I should not see {string} {string} from world {string}:') do |_quantity, item, world|
  shopping_list = ShoppingList.find_by(item: Item.find_by(name: item), level: world.to_i)
  expect(page).to have_no_selector("##{dom_id(shopping_list)}")
end

Then('I should see {string} marked as complete from world {string}') do |item, world|
  shopping_list = ShoppingList.find_by(item: Item.find_by(name: item), level: world.to_i)
  within "##{dom_id(shopping_list)}" do
    expect(page).to have_field("checked_shopping_list_#{shopping_list.id}", checked: true, disabled: true)
  end
end

Then('I should see {string} marked as incomplete from world {string}') do |item, world|
  shopping_list = ShoppingList.find_by(item: Item.find_by(name: item), level: world.to_i)
  within "##{dom_id(shopping_list)}" do
    expect(page).to have_field("checked_shopping_list_#{shopping_list.id}", checked: false, disabled: true)
  end
end
