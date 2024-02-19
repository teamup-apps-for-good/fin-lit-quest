# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'GET #logged_in?' do
    before do
      @player = Player.create!(name: 'Stella', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1,
                               email: 'test@test.com', provider: 'google-oauth2', uid: '1234')
    end

    context 'when user is logged in' do
      it 'returns the current character' do
        session[:user_id] = @player.id

        get :logged_in?

        expect(assigns(:current_user)).to eq(@player)
      end

      context 'but not in the database' do
        it 'resets session' do
          session[:user_id] = 100

          get :logged_in?

          expect(session[:user_id]).to be_nil
        end

        it 'redirects to the welcome path' do
          session[:user_id] = 100

          get :logged_in?

          expect(response).to redirect_to welcome_path
        end
      end
    end

    context 'when user is not logged in' do
      it 'returns nil' do
        session[:user_id] = nil

        get :logged_in?

        expect(assigns(:current_user)).to be_nil
      end
    end
  end
end
