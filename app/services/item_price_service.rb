# frozen_string_literal: true

# ItemPriceService
class ItemPriceService
  @previous_adjustments = {}

  def self.adjust_prices_for_character(character)
    character.items.each do |item|
      original_price = item.value
      adjusted_price = adjusted_price_for(item, character.day, original_price)

      puts "Item: #{item.name}, Original Price: #{original_price}, Adjusted Price: #{adjusted_price}"

      # Remember this adjustment for comparison next day
      @@previous_adjustments[item.id] = adjusted_price
    end
  end

  def self.adjusted_price_for(item, _day, original_price)
    # Start with a range of possible adjustments
    adjustments = [-5, 5]

    # Calculate a new price with each possible adjustment until it meets the criteria
    adjusted_price = original_price
    adjustments.shuffle.each do |adjustment|
      potential_price = original_price + adjustment
      next if potential_price < 1 # Skip if below minimum
      next if @@previous_adjustments[item.id] == potential_price # Skip if same as last day

      adjusted_price = potential_price
      break
    end

    [adjusted_price, 1].max # Ensure the price does not go below 1
  end
end
