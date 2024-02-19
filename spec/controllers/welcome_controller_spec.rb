require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe 'GET #index' do
    before do
      Player.create(name: 'Stella', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1,
                    email: 'test@test.com', provider: 'google-oauth2', uid: '1234')
    end

    context 'when user is logged in' do
      it 'redirects to the root path' do
        session[:user_id] = 1

        get :index

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      it 'does not redirect' do
        session[:user_id] = nil

        get :index

        expect(response).not_to be_redirect
      end
    end
  end
end
