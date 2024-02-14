# frozen_string_literal: true

# spec/factories/characters.rb
# spec/factories/characters.rb
FactoryBot.define do
  factory :character do
    name { 'NPCCharacter' }
    type { '' } # Default character type
    occupation { 'Unknown' }
    inventory_slots { 10 }
    balance { 1000 }
    current_level { 1 }
    personality { 'Neutral' }
    dialogue_content { 'Hello there!' }
    quantity_to_accept { 5 }
    quantity_to_offer { 5 }
    item_to_accept_id { nil }
    item_to_offer_id { nil }
    day { 1 }
    hour { 1 }
    era { 1 }

    trait :player do
      type { 'Player' }
      name { 'PlayerCharacter' }
    end
  end
end
