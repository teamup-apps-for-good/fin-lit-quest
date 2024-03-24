# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CounterOfferService do
  let(:item_to_give) { create(:item) }
  let(:item_to_want) { create(:item) }
  let(:player_character) { create(:character, :player) }
  let(:npc_character) { create(:character) }

  let(:offer_params) do
    {
      item_i_give_id: item_to_give.id,
      quantity_i_give: 5,
      item_i_want_id: item_to_want.id,
      quantity_i_want: 5
    }
  end

  subject(:service) { described_class.new(player_character, npc_character, offer_params) }

  describe '#execute_trade' do
    context 'when the trade is valid and items are available' do
      before do
        create(:inventory, character: player_character, item: item_to_give, quantity: 5)
        create(:inventory, character: npc_character, item: item_to_want, quantity: 5)
      end

      it 'returns true and performs the trade' do
        result, message = service.execute_trade

        expect(result).to be true
        expect(message).not_to be_empty

        # Optionally verify inventory updates
        updated_player_give_inventory = Inventory.find_by(character: player_character, item: item_to_give)
        updated_npc_want_inventory = Inventory.find_by(character: npc_character, item: item_to_want)

        updated_player_give_inventory.reload
        updated_npc_want_inventory.reload
      end

      it 'tells the user the trade was not the best deal when over offered' do
        offer_params[:quantity_i_want] = 4
        result, message = service.execute_trade

        expect(result).to be true
        expect(message).to be("Success, but that wasn't the best deal.")

        # Optionally verify inventory updates
        updated_player_give_inventory = Inventory.find_by(character: player_character, item: item_to_give)
        updated_npc_want_inventory = Inventory.find_by(character: npc_character, item: item_to_want)

        updated_player_give_inventory.reload
        updated_npc_want_inventory.reload
      end
    end

    context 'when the NPC does not have the item' do
      before do
        create(:inventory, character: player_character, item: item_to_give, quantity: 5)
        # Do not create inventory for npc_character to simulate absence of the item
      end

      it 'returns false with an appropriate error message' do
        result, message = service.execute_trade
        expect(result).to be false
        expect(message).to include('does not have the item you are trying to get')
      end
    end

    context 'when the trade is not valid due to valuation' do
      let(:item_to_give) { create(:item, value: 10) }
      let(:item_to_want) { create(:item, value: 100) }

      before do
        create(:inventory, character: player_character, item: item_to_give, quantity: 5)
        create(:inventory, character: npc_character, item: item_to_want, quantity: 5)
        # Ensure the service is re-initialized if needed to pick up new `let` values
        described_class.new(player_character, npc_character, offer_params)
      end

      it 'returns false with a valuation error message' do
        result, message = service.execute_trade
        expect(result).to be false
        expect(message).to include("#{npc_character.name} did not accept your offer!")
      end
    end
  end

  describe 'when given the same items with higher price to trade to different occupations' do
    before do
      Item.create(name: 'apple',
                  description: 'crunchy, fresh from the tree',
                  value: 2)

      Item.create(name: 'bread',
                  description: 'yummy, fresh from the oven',
                  value: 2)

      Character.create(name: 'Bobert',
                       occupation: :farmer,
                       inventory_slots: 20,
                       balance: 0,
                       current_level: 1)

      Character.create(name: 'Robert',
                       occupation: :merchant,
                       inventory_slots: 20,
                       balance: 0,
                       current_level: 1)

      @bobert = Character.find_by(name: 'Bobert')
      @robert = Character.find_by(name: 'Robert')

      @apple_item = Item.find_by(name: 'apple')
      @bread_item = Item.find_by(name: 'bread')

      Preference.create(occupation: 'merchant',
                        item: @bread_item,
                        multiplier: 3)
      Preference.create(occupation: 'farmer',
                        item: @apple_item,
                        multiplier: 2)

      @pref = Preference.find_by(occupation: @robert.occupation)
    end

    after do
      Preference.destroy_all
      Character.destroy_all
      Item.destroy_all
    end

    it 'should be accepted by an occupation that prefers it' do
      trade = described_class.new(player_character, @bobert,
                                  { item_i_give_id: @apple_item.id, quantity_i_give: 1,
                                    item_i_want_id: @bread_item.id, quantity_i_want: 2 })
      expect(trade.trade_is_valid?).to eq(true)
    end

    it 'should be rejected by an occupation that does not prefer it' do
      trade = described_class.new(player_character, @robert,
                                  { item_i_give_id: @apple_item.id, quantity_i_give: 1,
                                    item_i_want_id: @bread_item.id, quantity_i_want: 2 })
      expect(trade.trade_is_valid?).to eq(false)
    end
  end

  describe 'time variance' do
    before do
      Item.create(name: 'apple',
                  description: 'crunchy, fresh from the tree',
                  value: 2)

      Character.create(name: 'Bobert',
                       occupation: :farmer,
                       inventory_slots: 20,
                       balance: 0,
                       current_level: 1)

      @bobert = Character.find_by(name: 'Bobert')
      @apple_item = Item.find_by(name: 'apple')
    end

    after do
      Character.destroy_all
      Item.destroy_all
    end

    it 'should be 1.0 on the first day' do
      trade = described_class.new(player_character, @bobert,
                                  { item_i_give_id: @apple_item.id, quantity_i_give: 1,
                                    item_i_want_id: @apple_item.id, quantity_i_want: 1 })
      expect(trade.calculate_time_variance_for_trade(@apple_item, player_character)).to eq(1.0)
    end

    it 'should not be 1.0 on the second day' do
      player_character.update(day: 2)
      trade = described_class.new(player_character, @bobert,
                                  { item_i_give_id: @apple_item.id, quantity_i_give: 1,
                                    item_i_want_id: @apple_item.id, quantity_i_want: 1 })
      expect(trade.calculate_time_variance_for_trade(@apple_item, player_character)).not_to eq(1.0)
    end
  end

  describe '#execute_buy' do
    context 'when the buy is valid and the player can afford the items' do
      before do
        allow(service.instance_variable_get(:@validation_service)).to receive(:npc_has_item?).and_return(true)
        allow(service.instance_variable_get(:@validation_service)).to receive(:player_can_afford?).and_return(true)
        allow(Item).to receive(:find_by).with(id: offer_params[:item_i_want_id]).and_return(item_to_want)
      end

      it 'returns true and performs the buy transaction' do
        result, message = service.execute_buy

        expect(result).to be true
        expect(message).to eq("Successfully bought #{offer_params[:quantity_i_want]} #{item_to_want.name}!")
      end
    end

    context 'when the buy is invalid or the player cannot afford the items' do
      before do
        allow(service.instance_variable_get(:@validation_service)).to receive(:npc_has_item?).and_return(false)
        allow(service.instance_variable_get(:@validation_service)).to receive(:player_can_afford?).and_return(false)
        allow(MessageService).to receive(:generate_buy_error_message).and_return('Error message')
      end

      it 'returns false with an appropriate error message' do
        result, message = service.execute_buy

        expect(result).to be false
        expect(message).to eq('Error message')
      end
    end
  end

  describe '#execute_sell' do
    context 'when the sell is valid and the user has the item' do
      before do
        allow(service.instance_variable_get(:@validation_service)).to receive(:user_has_item?).and_return(true)
        allow(Item).to receive(:find_by).with(id: offer_params[:item_i_give_id]).and_return(item_to_give)
      end

      it 'returns true and performs the sell transaction' do
        result, message = service.execute_sell

        expect(result).to be true
        expect(message).to eq("Successfully sold #{offer_params[:quantity_i_give]} #{item_to_give.name}!")
      end
    end

    context 'when the sell is invalid or the user does not have the item' do
      before do
        allow(service.instance_variable_get(:@validation_service)).to receive(:user_has_item?).and_return(false)
        allow(MessageService).to receive(:generate_sell_error_message).and_return('Error message')
      end

      it 'returns false with an appropriate error message' do
        result, message = service.execute_sell

        expect(result).to be false
        expect(message).to eq('Error message')
      end
    end
  end

  describe '#perform_buy_transactions' do
    it 'updates the NPC inventory and player inventory and balance' do
      expect(InventoryService).to receive(:update_inventory).with(npc_character, offer_params[:item_i_want_id],
                                                                  -offer_params[:quantity_i_want])
      expect(InventoryService).to receive(:update_inventory).with(player_character, offer_params[:item_i_want_id],
                                                                  offer_params[:quantity_i_want])
      expect(player_character).to receive(:update!).with(balance:
        (player_character.balance - service.send(:total_price_of_items_wanted)))

      service.send(:perform_buy_transactions)
    end
  end

  describe '#perform_sell_transactions' do
    it 'updates the player inventory and balance and NPC inventory' do
      expect(InventoryService).to receive(:update_inventory).with(player_character, offer_params[:item_i_give_id],
                                                                  -offer_params[:quantity_i_give])
      expect(player_character).to receive(:update!).with(balance:
        (player_character.balance + service.send(:total_sale_price_of_items_given)))
      expect(InventoryService).to receive(:update_inventory).with(npc_character, offer_params[:item_i_give_id],
                                                                  offer_params[:quantity_i_give])

      service.send(:perform_sell_transactions)
    end
  end
end
