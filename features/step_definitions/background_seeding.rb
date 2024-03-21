# frozen_string_literal: true

Given('the following players exist:') do |players|
  players.hashes.each do |player|
    Player.create!(player)
  end
end

Given('the following non-players exist:') do |nonplayers|
  nonplayers.hashes.each do |nonplayer|
    # cannot use symbols to access the hash here for setting
    item = Item.find_by(name: nonplayer['item_to_accept'])
    nonplayer['item_to_accept'] = item
    item = Item.find_by(name: nonplayer['item_to_offer'])
    nonplayer['item_to_offer'] = item
    Nonplayer.create!(nonplayer)
  end
end

Given('the following items exist:') do |items|
  items.hashes.each do |item|
    Item.create!(item)
  end
end

Given('the following inventory entries exist:') do |inventories|
  inventories.hashes.each do |inventory_entry|
    item = Item.find_by(name: inventory_entry['item'])
    inventory_entry['item'] = item
    character = Character.find_by(name: inventory_entry['character'])
    inventory_entry['character'] = character
    Inventory.create!(inventory_entry)
  end
end

Given('the following shopping list entries exist:') do |shoppinglists|
  # table is a Cucumber::MultilineArgument::DataTable
  shoppinglists.hashes.each do |shoppinglist_entry|
    item = Item.find_by(name: shoppinglist_entry['item'])
    shoppinglist_entry['item'] = item
    ShoppingList.create!(shoppinglist_entry)
  end
end

Given('the following preference entries exist:') do |preferences|
  # table is a Cucumber::MultilineArgument::DataTable
  preferences.hashes.each do |preference|
    item = Item.find_by(name: preference['item'])
    preference['item'] = item

    Preference.create!(preference)
  end
end

Given('the following inventory table exists:') do |inventories|
  inventories.hashes.each do |inventory_entry|
    item = Item.find_by(name: inventory_entry['item'])
    inventory_entry['item'] = item
    character = Character.find_by(name: inventory_entry['character'])
    inventory_entry['character'] = character
    Inventory.create!(inventory_entry)
  end
end

Given('the following expenses exist:') do |expenses|
  expenses.hashes.each do |expense|
    item = Item.find_by(name: expense['item'])
    expense['item'] = item
    Expense.create!(expense)
  end
end

Given('the following starter item table exists:') do |starters|
  starters.hashes.each do |starter_entry|
    item = Item.find_by(name: starter_entry['item'])
    starter_entry['item'] = item
    StarterItem.create!(starter_entry)
  end
end

Given('the following allowance entries exist:') do |allowances|
  allowances.hashes.each do |allowance|
    unless allowance['item'].nil?
      item = Item.find_by(name: allowance['item'])
      allowance['item'] = item
    end
    Allowance.create!(allowance)
  end
end
