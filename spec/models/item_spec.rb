# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validation' do
    before do
      @item_data = { name: 'test item', description: 'test', value: 1 }
    end
    %i[name description value].each do |tag|
      it "makes sure #{tag} exists" do
        data = @item_data
        data[tag] = nil
        item = Item.new(data)
        expect(item.valid?).to be false
      end
    end
  end
end
