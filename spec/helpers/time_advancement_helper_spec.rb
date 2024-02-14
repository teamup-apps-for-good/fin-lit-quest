# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimeAdvancementHelper do
  let(:character) { instance_double('Character', hour: 10, day: 1, era: 1) }

  describe '.increment_hour' do
    it 'increments the hour by one if it is less than 10' do
      allow(character).to receive(:increment!).with(:hour)
      allow(character).to receive(:hour).and_return(9, 10)
      expect(character).not_to receive(:update).with(hour: 1)

      described_class.increment_hour(character)
    end

    it 'resets the hour to 1 and increments the day if hour exceeds 10' do
      allow(character).to receive(:increment!).with(:hour)
      allow(character).to receive(:hour).and_return(11, 12)
      expect(character).to receive(:update).with(hour: 1).twice
      expect(character).to receive(:increment!).with(:day)

      described_class.increment_hour(character)
    end
  end

  describe '.increment_day' do
    it 'increments the day by one' do
      expect(character).to receive(:increment!).with(:day)
      expect(character).to receive(:update).with(hour: 1)

      described_class.increment_day(character)
    end
  end

  describe '.increment_era' do
    it 'increments the era by one and resets the day and hour' do
      expect(character).to receive(:increment!).with(:era)
      expect(character).to receive(:update).with(day: 1, hour: 1)

      described_class.increment_era(character)
    end
  end

  describe '.display_current_time_for_character' do
    it 'returns formatted time string for the character' do
      allow(character).to receive(:present?).and_return(true)
      allow(character).to receive(:hour).and_return(1)
      allow(character).to receive(:day).and_return(1)
      allow(character).to receive(:era).and_return(1)

      expected_string = '08:00 AM on Day 1, Era 1'
      expect(described_class.display_current_time_for_character(character)).to eq(expected_string)
    end

    it 'returns a not found message if the character is not present' do
      expect(described_class.display_current_time_for_character(nil))
        .to eq('Character details incomplete or not found.')
    end
  end
end
