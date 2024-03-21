Given('{string} has a balance of {string}') do |character_name, balance|
   character = Character.find_by(name: character_name)
   character.update(balance: balance.to_i)
end
