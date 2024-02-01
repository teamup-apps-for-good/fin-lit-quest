# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CounterOfferController, type: :controller do
  before(:each) do
    @player_character = FactoryBot.create(:character, type: 'Player', name: 'PlayerCharacter')
    @npc_character = FactoryBot.create(:character, name: 'NPCCharacter')
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
    @player_inventory_item = FactoryBot.create(:inventory, character: @player_character, item: @item1, quantity: 5)
    @npc_inventory_item = FactoryBot.create(:inventory, character: @npc_character, item: @item2, quantity: 5)
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { name: @npc_character.name }
      expect(response).to render_template(:show)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'completes the trade and redirects' do
        post :create, params: {
          name: @npc_character.name,
          item_i_give_id: @item1.id,
          quantity_i_give: 1,
          item_i_want_id: @item2.id,
          quantity_i_want: 1
        }
        expect(flash[:notice]).to eq('Success!')
        expect(response).to redirect_to(counter_offer_path(name: @npc_character.name))
      end
    end

    context 'when trade value is insufficient' do
      it 'sets a failure flash message and redirects' do
        post :create, params: {
          name: @npc_character.name,
          item_i_give_id: @item1.id,
          quantity_i_give: 1,
          item_i_want_id: @item2.id,
          quantity_i_want: 10
        }
        expect(flash[:alert]).to eq("#{@name} did not accept your offer!")
        expect(response).to redirect_to(counter_offer_path(name: @npc_character.name))
      end
    end

    context 'with invalid parameters' do
      it 'redirects to root path' do
        request.env['HTTP_REFERER'] = nil

        post :create, params: { name: @npc_character.name }

        expect(flash[:alert]).to eq('Please fill in all required fields')
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when NPC does not have the item' do
      it 'sets a failure flash message and redirects' do
        post :create, params: {
          name: @npc_character.name,
          item_i_give_id: @item1.id,
          quantity_i_give: 1,
          item_i_want_id: 999, # Assuming this ID does not exist
          quantity_i_want: 1
        }
        expect(flash[:alert]).to match(/does not have the item you are trying to get/)
        expect(response).to redirect_to(counter_offer_path(name: @npc_character.name))
      end
    end
  end

  context 'when trade results in negative inventory' do
    it 'raises a NegativeInventoryError' do
      allow_any_instance_of(CounterOfferController)
        .to receive(:inventory_for)
        .and_return({ 'SomeItem' => -1 })

      expect do
        post :create, params: {
          name: @npc_character.name,
          item_i_give_id: @item1.id,
          quantity_i_give: 20,
          item_i_want_id: @item2.id,
          quantity_i_want: 1
        }
      end.to raise_error(NegativeInventoryError, /Invalid quantity for item/)
    end
  end
end
