# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    Player.create!(name: 'Stella', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1,
                   email: 'test@test.com', provider: 'google-oauth2', uid: '1234')
  end

  describe 'GET #logged_in' do
    before do
      @player = Player.create!(name: 'Stella', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1,
                               email: 'test@test.com', provider: 'google-oauth2', uid: '1234')
    end

    context 'when user is logged in' do
      it 'returns the current character' do
        session[:user_id] = @player.id

        get :logged_in

        expect(assigns(:current_user)).to eq(@player)
      end

      context 'but not in the database' do
        it 'resets session' do
          session[:user_id] = 100

          get :logged_in

          expect(session[:user_id]).to be_nil
        end
      end
    end

    context 'when user is not logged in' do
      it 'returns nil' do
        session[:user_id] = nil

        get :logged_in

        expect(assigns(:current_user)).to be_nil
      end
    end
  end

  describe 'GET #login' do
    context 'when user is logged in' do
      it 'redirects to the root path' do
        session[:user_id] = 1

        get :login

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      it 'does not redirect' do
        session[:user_id] = nil

        get :login

        expect(response).not_to be_redirect
      end
    end
  end
end
