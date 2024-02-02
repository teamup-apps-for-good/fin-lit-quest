require 'rails_helper'

RSpec.describe CounterOfferController, type: :controller do
  describe 'GET #show' do
    it 'renders the show template' do
      character = create(:character)
      allow(CharacterInventoryService).to receive(:build_context).and_return(double(character: character))

      get :show

      expect(response).to render_template(:show)
    end
  end

  describe 'POST #create' do
    let(:item_i_give) { create(:item) }
    let(:item_i_want) { create(:item) }
    let(:character) { create(:character, :player) }
    let(:player_inventory) { create(:inventory, character: character, item: item_i_give, quantity: 10) }
    let(:wanted_inventory) { create(:inventory, character: character, item: item_i_want, quantity: 10) }

    let(:valid_params) do
      {
        item_i_give_id: item_i_give.id,
        quantity_i_give: 2,
        item_i_want_id: item_i_want.id,
        quantity_i_want: 2
      }
    end

    let(:invalid_params) do
      {
        item_i_give_id: nil,
        quantity_i_give: nil,
        item_i_want_id: nil,
        quantity_i_want: nil
      }
    end

    context 'with valid parameters' do
      before do
        allow(CharacterInventoryService).to receive(:build_context).and_return(
          Context.new(
            name: character.name,
            character: character,
            player_character: character,
            player_inventory: [player_inventory, wanted_inventory], # This array represents the character's full inventory
            npc_inventory: character.inventories # This may need to be adjusted depending on your app's logic
          )
        )
      end

      it 'executes counter offer and redirects to the show page' do
        post :create, params: { counter_offer: valid_params }
        character.reload
        expect(flash[:notice]).to eq('Success!')
        expect(response).to redirect_to(counter_offer_path(name: character.name))
      end

      it 'updates the inventories correctly' do
        post :create, params: { counter_offer: valid_params }
        character.reload # Make sure to reload the character to get the updated inventory
        expect(character.inventories.find_by(item_id: item_i_give.id).quantity)
          .to eq(10 - valid_params[:quantity_i_give])
        expect(character.inventories.find_by(item_id: item_i_want.id).quantity)
          .to eq(10 + valid_params[:quantity_i_want])
      end
    end

    context 'with invalid parameters' do
      it 'sets flash alert and redirects to the previous page' do
        post :create, params: { counter_offer: invalid_params }
        expect(flash[:alert]).to eq('Please fill in all required fields')
        expect(response).to redirect_to(request.referer || root_path)
      end
    end
  end
end
