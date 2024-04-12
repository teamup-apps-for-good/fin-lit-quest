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
      {
        name: npc_character.name,
        item_i_give_id: '',
        quantity_i_give: '2',
        item_i_want_id: '3',
        quantity_i_want: '4'
      }
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
        allow_any_instance_of(CounterOfferService).to receive(:execute_trade).and_return([true, 'Success!'])
        post :create, params: valid_params
        expect(flash[:notice]).to eq('Success!')
        expect(response).to redirect_to(trade_path(id: npc_character.id))
      end
    end

    context 'when trade is unsuccessful' do
      it 'sets flash alert with an error message and redirects' do
        allow_any_instance_of(CounterOfferService).to receive(:execute_trade)
          .and_return([false, 'Trade failed due to insufficient items'])
        post :create, params: valid_params
        expect(flash[:alert]).to eq('Trade failed due to insufficient items')
        expect(response).to redirect_to(trade_path(id: npc_character.id))
      end
    end

    context 'when character.hour is 10' do
      before do
        @user = Player.create!(name: 'Test User', occupation: :farmer, inventory_slots: 5, balance: 0,
                               current_level: 1, email: 'test@test.com', provider: 'google-oauth2',
                               uid: '5678', day: 1, hour: 10)
        session[:user_id] = @user.id
        npc_character.update(hour: 10) # Set the character's hour to 10
      end

      it 'redirects to root path with a notice' do
        post :create, params: valid_params
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('It is too late! Move to the next day')
      end
    end
  end
  describe '#set_inventories' do
    let(:item_to_offer) { create(:item, name: 'Offered Item') }
    let(:item_to_accept) { create(:item, name: 'Requested Item') }
    let(:npc_character) do
      create(:character, name: 'NPCCharacter', item_to_offer_id: item_to_offer.id, item_to_accept_id: item_to_accept.id)
    end

    before do
      allow(CharacterInventoryService).to receive(:build_context_by_id)
        .and_return(double(player_character: nil, character: npc_character, name: npc_character.name))
    end

    it 'sets the player and NPC inventories' do
      get :show, params: { id: npc_character.id }
      expect(assigns(:inventory_hash_player)).to eq(InventoryService.inventory_for(@user))
      expect(assigns(:inventory_hash_npc)).to eq(InventoryService.inventory_for(npc_character))
    end
  end

  describe 'GET #barter' do
    let(:item_to_offer) { create(:item, name: 'Offered Item') }
    let(:item_to_accept) { create(:item, name: 'Requested Item') }
    let(:npc_character) do
      create(:character, name: 'NPCCharacter', item_to_offer_id: item_to_offer.id, item_to_accept_id: item_to_accept.id)
    end

    before do
      allow(CharacterInventoryService).to receive(:build_context_by_id)
        .and_return(double(player_character: nil, character: npc_character, name: npc_character.name))
    end

    it 'renders the barter template' do
      get :barter, params: { id: npc_character.id }
      expect(response).to render_template('barter')
    end
  end

  describe 'GET #buy' do
    let(:item_to_offer) { create(:item, name: 'Offered Item') }
    let(:item_to_accept) { create(:item, name: 'Requested Item') }
    let(:npc_character) do
      create(:character, name: 'NPCCharacter', item_to_offer_id: item_to_offer.id, item_to_accept_id: item_to_accept.id)
    end

    before do
      allow(CharacterInventoryService).to receive(:build_context_by_id)
        .and_return(double(player_character: nil, character: npc_character, name: npc_character.name))
    end

    it 'renders the buy template' do
      get :buy, params: { id: npc_character.id }
      expect(response).to render_template('buy')
    end
  end

  describe 'GET #sell' do
    let(:item_to_offer) { create(:item, name: 'Offered Item') }
    let(:item_to_accept) { create(:item, name: 'Requested Item') }
    let(:npc_character) do
      create(:character, name: 'NPCCharacter', item_to_offer_id: item_to_offer.id, item_to_accept_id: item_to_accept.id)
    end

    before do
      allow(CharacterInventoryService).to receive(:build_context_by_id)
        .and_return(double(player_character: nil, character: npc_character, name: npc_character.name))
    end

    it 'renders the sell template' do
      get :sell, params: { id: npc_character.id }
      expect(response).to render_template('sell')
    end
  end

  describe 'POST #buy_create' do
    let(:item_to_offer) { create(:item, name: 'Offered Item') }
    let(:item_to_accept) { create(:item, name: 'Requested Item') }
    let(:npc_character) do
      create(:character, name: 'NPCCharacter', item_to_offer_id: item_to_offer.id, item_to_accept_id: item_to_accept.id)
    end
    let(:buy_params) { { item_i_want_id: item_to_offer.id, quantity_i_want: '5' } }

    before do
      allow(CharacterInventoryService).to receive(:build_context_by_id)
        .and_return(double(player_character: nil, character: npc_character, name: npc_character.name))
    end

    context 'when buy is successful' do
      it 'redirects to trade path with a notice' do
        allow_any_instance_of(BuyCreateService).to receive(:execute).and_return([true, 'Buy success!'])
        post :buy_create, params: { id: npc_character.id, **buy_params }
        expect(response).to redirect_to(trade_path(id: npc_character.id))
        expect(flash[:notice]).to eq('Buy success!')
      end
    end

    context 'when buy is unsuccessful' do
      it 'sets flash alert and redirects' do
        allow_any_instance_of(BuyCreateService).to receive(:execute).and_return([false, 'Buy failed!'])
        post :buy_create, params: { id: npc_character.id, **buy_params }
        expect(flash[:alert]).to eq('Buy failed!')
        expect(response).to redirect_to(request.referer || root_path)
      end
    end
  end

  describe 'POST #sell_create' do
    let(:item_to_offer) { create(:item, name: 'Offered Item') }
    let(:item_to_accept) { create(:item, name: 'Requested Item') }
    let(:npc_character) do
      create(:character, name: 'NPCCharacter', item_to_offer_id: item_to_offer.id, item_to_accept_id: item_to_accept.id)
    end
    let(:sell_params) { { item_i_give_id: item_to_accept.id, quantity_i_give: '5' } }

    before do
      allow(CharacterInventoryService).to receive(:build_context_by_id)
        .and_return(double(player_character: nil, character: npc_character, name: npc_character.name))
    end

    context 'when sell is successful' do
      it 'redirects to trade path with a notice' do
        allow_any_instance_of(SellCreateService).to receive(:execute).and_return([true, 'Sell success!'])
        post :sell_create, params: { id: npc_character.id, **sell_params }
        expect(response).to redirect_to(trade_path(id: npc_character.id))
        expect(flash[:notice]).to eq('Sell success!')
      end
    end

    context 'when sell is unsuccessful' do
      it 'sets flash alert and redirects' do
        allow_any_instance_of(SellCreateService).to receive(:execute).and_return([false, 'Sell failed!'])
        post :sell_create, params: { id: npc_character.id, **sell_params }
        expect(flash[:alert]).to eq('Sell failed!')
        expect(response).to redirect_to(request.referer || root_path)
      end
    end
  end
  describe 'GET #calculate_price' do
    let(:item) { create(:item) }
    let(:quantity) { 5 }
    let(:transaction_type) { 'buy' }
    # Create a player directly
    let(:player) do
      Player.create(name: 'TestPlayer', email: 'test@example.com', provider: 'test', uid: '123')
    end
    let(:character) { create(:character, :player) } # Create a player character

    before do
      allow(controller).to receive(:current_user).and_return(player)
      allow(CharacterInventoryService).to receive(:build_context_by_id).and_return(double(character:))
      allow(PriceCalculationService).to receive_message_chain(:new, :calculate_total_price).and_return(100.0)
    end

    it 'calculates the total price and renders it as JSON' do
      get :calculate_price,
          params: { id: character.id, item_id: item.id, quantity:, transaction_type: }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'total_price' => 100.0 })
    end
  end
end
