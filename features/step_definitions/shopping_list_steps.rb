# frozen_string_literal: true

Given('the following shopping list table exists:') do |shoppinglists|
  # table is a Cucumber::MultilineArgument::DataTable
  shoppinglists.hashes.each do |shoppinglist_entry|
    item = Item.find_by(name: shoppinglist_entry['item'])
    shoppinglist_entry['item'] = item
    ShoppingList.create(shoppinglist_entry)
  end
end

Given('I am on the shopping list page') do
  visit shopping_lists_path
end

Then('I should see {int} apple:') do |num|
  # Then('I should see {float} apple:') do |float|
  shopping_list = ShoppingList.find_by(item: Item.find_by(name: 'apple'), level: 1)
  within "#shopping_list_#{shopping_list.id}" do
    expect(page).to have_content('Item: apple')
    expect(page).to have_content('Level: 1')
    expect(page).to have_content('Quantity: ' + num.to_s)
  end
end

Then('I should see {int} orange:') do |num|
  # Then('I should see {float} orange:') do |float|
  shopping_list = ShoppingList.find_by(item: Item.find_by(name: 'orange'), level: 1)
  within "#shopping_list_#{shopping_list.id}" do
    expect(page).to have_content('Item: orange')
    expect(page).to have_content('Level: 1')
    expect(page).to have_content('Quantity: ' + num.to_s)
  end
end

Then('I should see {int} wheat:') do |num|
  # Then('I should see {float} wheat:') do |float|
  shopping_list = ShoppingList.find_by(item: Item.find_by(name: 'wheat'), level: 1)
  within "#shopping_list_#{shopping_list.id}" do
    expect(page).to have_content('Item: wheat')
    expect(page).to have_content('Level: 1')
    expect(page).to have_content('Quantity: ' + num.to_s)
  end
end

Then('I should see {int} fish:') do |num|
  # Then('I should see {float} fish:') do |float|
  shopping_list = ShoppingList.find_by(item: Item.find_by(name: 'fish'), level: 1)
  within "#shopping_list_#{shopping_list.id}" do
    expect(page).to have_content('Item: fish')
    expect(page).to have_content('Level: 1')
    expect(page).to have_content('Quantity: ' + num.to_s)
  end
end

Then('I should see {int} bread:') do |num|
  # Then('I should see {float} bread:') do |float|
  shopping_list = ShoppingList.find_by(item: Item.find_by(name: 'bread'), level: 1)
  within "#shopping_list_#{shopping_list.id}" do
    expect(page).to have_content('Item: bread')
    expect(page).to have_content('Level: 1')
    expect(page).to have_content('Quantity: ' + num.to_s)
  end
end

Then('I should see orange marked as complete') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see apple marked as complete') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see fish marked as complete') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see bread marked as incomplete') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see wheat marked as incomplete') do
  pending # Write code here that turns the phrase above into concrete actions
end
