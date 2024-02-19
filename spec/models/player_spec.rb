# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  describe 'validation' do
    before do
      @player_data = {
        name: 'Name',
        occupation: :merchant,
        inventory_slots: 1,
        balance: 1,
        type: Player,
        current_level: 1
      }
    end
    %i[name occupation inventory_slots balance current_level email uid provider].each do |tag|
      it "makes sure #{tag} exists" do
        data = @player_data
        data[tag] = nil
        player = Player.new(data)
        expect(player.valid?).to be false
      end
    end

    it 'allows valid objects' do
      data = @player_data
      player = Player.new(data)
      expect(player.valid?).to be true
    end

    it 'ensures level is positive' do
      data = @player_data
      data[:current_level] = -1
      player = Player.new(data)
      expect(player.valid?).to be false
    end
  end
end
