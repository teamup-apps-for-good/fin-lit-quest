Given('the following inventory table exists:') do |inventory_table|
  inventory_table.hashes.each do |inventory|
    item = Item.find_by(name: inventory[:item])
    character = Character.find_by(name: inventory[:owner])
    Inventory.create({item: item.id, owner_id: character.id, quantity: inventory[:quantity]})
  end
end

Given('the following items exist:') do |item_table|
  item_table.hashes.each do |item|
    Item.create item
  end
end

Given('I am on the {string} page') do |string|
  case string.downcase
  when 'character'
    visit character_page
  when 'non-players'
    visit nonplayers_path
  else
    raise "failed to find page"
  end
end

Then('I should be on the {string} page for {string}') do |string, string2|
  case string.downcase
  when 'player'
    expect(current_page).to eq(player_path(Player.find_by(name: string2)))
  when 'non-player'
    expect(current_page).to eq(nonplayer_path(Nonplayer.find_by(name: string2)))
  when 'inventory'
    expect(current_page).to eq(player_inventory_path(Player.find_by(name: string2)))
  else
    raise "failed to find page"
  end
end

Then('I should see {string} as a description for {string}') do |string, string2|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see {string} for {string}') do |string, string2|
  pending # Write code here that turns the phrase above into concrete actions
end
