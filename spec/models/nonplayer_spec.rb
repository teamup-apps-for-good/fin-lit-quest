# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nonplayer, type: :model do
  describe 'validation' do
    before do
      item = Item.new({ name: 'test item', description: 'test', value: 1 })
      @nonplayer_data = {
        name: 'Name',
        occupation: :merchant,
        inventory_slots: 1,
        balance: 1,
        type: Nonplayer,
        current_level: 1,
        dialogue_content: 'test',
        quantity_to_accept: 1,
        quantity_to_offer: 1,
        item_to_accept: item.id,
        item_to_offer: item.id
      }
    end
    %i[name occupation inventory_slots balance current_level personality dialogue_content
       quantity_to_accept quantity_to_offer item_to_accept item_to_offer].each do |tag|
      it "makes sure #{tag} exists" do
        data = @nonplayer_data
        data[tag] = nil
        nonplayer = Nonplayer.new(data)
        expect(nonplayer.valid?).to be false
      end
    end
  end
end
