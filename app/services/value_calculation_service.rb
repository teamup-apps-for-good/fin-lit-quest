# frozen_string_literal: true

# Service class that calculates the value of items based on character preferences and time variance.
class ValueCalculationService
  def self.value_of(character, item_id, quantity)
    item = Item.find_by(id: item_id)
    pref = Preference.find_by(occupation: character.occupation)
    total_value = calculate_total_value(item_id, quantity)

    time_variance = calc_time_variance(item, character)

    adjusted_value = if pref && (pref.item.id == item_id.to_i)
                       total_value * pref.multiplier * time_variance
                     else
                       total_value * time_variance
                     end
    adjusted_value.ceil
  end

  def self.calculate_total_value(item_id, quantity)
    item = Item.find_by(id: item_id)
    item&.value.to_i * quantity
  end

  def self.calc_time_variance(item, character)
    return 1.0 if character.day == 1

    seed = (character.day << 100) + item.id
    rng = Random.new(seed)
    min = 0.5
    max = 1.5
    rng.rand(min..max)
  end
end
