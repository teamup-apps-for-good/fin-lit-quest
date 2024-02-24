# frozen_string_literal: true

# ItemPriceService
class ItemPriceService
  # Calculates the item value using the preference multiplier and time variance
  def self.calc_item_value(item, pref, player)
    value = item.value
    profession_bias = pref.multiplier # Assuming pref is already the correct preference object
    time_bias = calc_time_variance(item, player)
    (value * profession_bias * time_bias).round
  end

  # Calculates time variance based on player's day and item ID
  def self.calc_time_variance(item, player)
    seed = (player.day << 100) + item.id
    rng = Random.new(seed)
    min = 0.5
    max = 1.5
    rng.rand(min..max) # Corrected to use Ruby's rand method correctly
  end
end
