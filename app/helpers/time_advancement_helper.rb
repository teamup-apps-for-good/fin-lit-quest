# frozen_string_literal: true

# Time Advancement Helper
module TimeAdvancementHelper
  HOUR_MAPPINGS = {
    1 => '08:00 AM', 2 => '09:00 AM', 3 => '10:00 AM', 4 => '11:00 AM',
    5 => '12:00 PM', 6 => '01:00 PM', 7 => '02:00 PM', 8 => '03:00 PM',
    9 => '04:00 PM', 10 => '05:00 PM', 11 => '06:00 PM'
  }.freeze

  def self.increment_hour(character)
    new_hour = character.hour + 1
    if new_hour > 10
      character.update(hour: 1)
      increment_day(character)
    else
      character.update(hour: new_hour)
    end
  end

  def self.increment_day(character)
    character.increment!(:day)
    character.update(hour: 1)
  end

  def self.increment_era(character)
    character.increment!(:era)
    character.update(day: 1, hour: 1)
  end

  def self.display_current_time_for_character(character)
    return 'Character details incomplete or not found.' unless character.present?

    formatted_hour = HOUR_MAPPINGS[character.hour] || 'Invalid hour'
    "#{formatted_hour} on Day #{character.day}, Era #{character.era}"
  end
end
