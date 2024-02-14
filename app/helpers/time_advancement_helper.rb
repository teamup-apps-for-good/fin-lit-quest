# frozen_string_literal: true

# Time Advancement Helper
module TimeAdvancementHelper
  def self.increment_hour(character)
    character.increment!(:hour)
    if character.hour >= 24
      character.update(hour: 0)
      increment_day(character)
    end
  end

  def self.increment_day(character)
    character.increment!(:day)
  end
end

def display_current_time_for_character(character)
  if character.present?
    # Adjusting the hour to a 12-hour format with AM/PM
    formatted_hour = if character.hour < 8
                       format('%02d:00 AM', character.hour)
                     elsif character.hour < 12
                       format('%02d:00 AM', character.hour)
                     elsif character.hour < 20
                       format('%02d:00 PM', character.hour - 12)
                     else
                       format('%02d:00 PM', character.hour - 12)
                     end
    "#{formatted_hour} on Day #{character.day}, Era #{character.era}"
  else
    "Character details incomplete or not found."
  end
end

  
  
  
  


  