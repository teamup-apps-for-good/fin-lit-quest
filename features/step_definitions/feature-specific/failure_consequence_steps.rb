# frozen_string_literal: true

# features/step_definitions/expense_steps.rb

Given('the following expenses table exists:') do |table|
  table.hashes.each do |expense_row|
    # Assuming you have a way to find an item_id based on the 'item' description
    # This might involve looking up an Item record by name or another attribute
    item = Item.find_by_name(expense_row['item']) # Adjust the find_by_ method as needed

    # Create an Expense record using the correct column names
    Expense.create!(
      frequency: expense_row['type'],  # Assuming 'type' maps to 'frequency'
      number: expense_row['value'],    # Assuming 'value' maps to 'number'
      item_id: item.id,                # Using the id of the item found above
      quantity: expense_row['quantity']
    )
  end
end

Then('I should be on the game over page') do
  expect(current_path).to eq(game_over_path)
end

Then('{string} should be on level {string}') do |player_name, expected_level|
  player = Player.find_by(name: player_name)
  expect(player.current_level.to_s).to eq(expected_level)
end

Given('{string} is on level {string}') do |player_name, current_level|
  player = Player.find_by(name: player_name)
  player.update(current_level:)
end

Given('I am on the game over page') do
  visit(game_over_path)
end

Then('{string} should have a balance of {string}') do |player_name, balance|
  player = Player.find_by(name: player_name)
  expect(player.balance.to_s).to eq(balance)
end
