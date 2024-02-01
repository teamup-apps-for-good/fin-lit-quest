require 'rails_helper'

RSpec.describe CounterOfferController, type: :request do
    describe 'GET #show' do
    it 'renders the show template' do
      character = create(:character)
      
      # Stub the CharacterInventoryService to return a double with a name attribute
      allow(CharacterInventoryService).to receive(:build_context).and_return(double(character: character, name: 'CharacterName'))
      
      get '/counter_offer/show'
    
      expect(response).to render_template(:show)
      expect(response.body).to include('Counter Offer for CharacterName') # Check if the name is correctly displayed in the view
    end
  end
  

  describe 'POST #create' do
    let(:valid_params) do
      {
        item_i_give_id: 1,
        quantity_i_give: 2,
        item_i_want_id: 3,
        quantity_i_want: 4
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
      it 'executes counter offer and redirects to the show page' do
        # Your valid_params test here
      end
    end

    context 'with invalid parameters' do
      it 'sets flash alert and redirects to the previous page' do
        post '/counter_offer/create', params: { counter_offer: invalid_params } # Use the URL path and wrap invalid_params
        expect(flash[:alert]).to eq('Please fill in all required fields')
        expect(response).to redirect_to(request.referer || root_path)
      end
    end
  end
end
