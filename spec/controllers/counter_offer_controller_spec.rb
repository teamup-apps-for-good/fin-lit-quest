# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CounterOfferController, type: :controller do
  before do
    @user = Player.create!(name: 'Test User', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1,
                           email: 'test@test.com', provider: 'google-oauth2', uid: '1234', day: 1, hour: 1)
    session[:user_id] = @user.id
  end
  describe 'POST #create' do
    let(:item_to_offer) { create(:item, name: 'Offered Item') }
    let(:item_to_accept) { create(:item, name: 'Requested Item') }
    let(:npc_character) do
      create(:character, name: 'NPCCharacter', item_to_offer_id: item_to_offer.id, item_to_accept_id: item_to_accept.id)
    end
    let(:player_character) { create(:character, :player, name: 'PlayerCharacter') }

    let(:valid_params) do
      {
        name: npc_character.name,
        item_i_give_id: item_to_accept.id.to_s,
        quantity_i_give: '5',
        item_i_want_id: item_to_offer.id.to_s,
        quantity_i_want: '5'
      }
    end

    let(:invalid_params) do
      { name: npc_character.name, item_i_give_id: '', quantity_i_give: '2', item_i_want_id: '3', quantity_i_want: '4' }
    end

    before do
      create(:inventory, character: npc_character, item: item_to_offer, quantity: 5)
      create(:inventory, character: player_character, item: item_to_accept, quantity: 5)
      allow(CharacterInventoryService).to receive(:build_context_by_id)
        .and_return(double(player_character:, character: npc_character, name: npc_character.name))
    end

    context 'with invalid parameters' do
      it 'sets the flash alert and redirects to the referer or root path' do
        request.env['HTTP_REFERER'] = '/previous_page'
        post :create, params: invalid_params
        expect(flash[:alert]).to eq('Please fill in all required fields')
        expect(response).to redirect_to('/previous_page')
      end
    end

    context 'when trade is successful' do
      it 'sets flash notice and redirects' do
        allow_any_instance_of(CounterOfferService).to receive(:execute_trade).and_return([true, ''])
        post :create, params: valid_params
        expect(flash[:notice]).to eq('Success!')
        expect(response).to redirect_to(counter_offer_path(id: npc_character.id))
      end
    end

    context 'when trade is unsuccessful' do
      it 'sets flash alert with an error message and redirects' do
        allow_any_instance_of(CounterOfferService).to receive(:execute_trade)
          .and_return([false, 'Trade failed due to insufficient items'])
        post :create, params: valid_params
        expect(flash[:alert]).to eq('Trade failed due to insufficient items')
        expect(response).to redirect_to(counter_offer_path(id: npc_character.id))
      end
    end

    context 'when character.hour is 10' do
      it 'redirects to root path with a notice' do
        allow(Player).to receive(:first).and_return(double(hour: 10))
        post :create, params: valid_params
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('It is too late! Move to the next day')
      end
    end
  end
end
