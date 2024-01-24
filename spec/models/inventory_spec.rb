# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe 'validation' do
    before do
      item = Item.new({ name: 'test item', description: 'test', value: 1 })
      character = Character.create(name: 'Stella',
                                   occupation: :farmer,
                                   inventory_slots: 20,
                                   balance: 0,
                                   current_level: 1)
      @inventory_data = {
        item:,
        character:,
        quantity: 1
      }
    end
    %i[item character quantity].each do |tag|
      it "makes sure #{tag} exists" do
        data = @inventory_data
        data[tag] = nil
        inventory = Inventory.new(data)
        expect(inventory.valid?).to be false
      end
    end
  end
end
