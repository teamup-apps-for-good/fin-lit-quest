# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    @player = Player.create!(name: 'Stella', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1,
                             email: 'test@test.com', provider: 'google_oauth2', uid: '1234', day: 1, hour: 1)
  end

  describe 'GET #logged_in' do
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

  describe 'GET #logout' do
    context 'when the user is logged in' do
      it 'logs out the user' do
        get :logout
        expect(session[:user_id]).to be_nil
      end

      it 'redirects them to the welcome page' do
        get :logout
        expect(response).to redirect_to(welcome_path)
      end
    end
  end

  describe 'GET #omniauth' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, {
                                 uid: '1234',
                                 info: {
                                   name: 'Stella',
                                   email: 'test@test.com'
                                 }
                               })
      OmniAuth.config.add_mock(:github, {
                                 uid: '1234',
                                 info: {
                                   name: 'Stella',
                                   email: 'test@test.com'
                                 }
                               })
    end
    context 'when the user is logged out' do
      before do
        session[:user_id] = nil
      end

      context 'if they have logged in before' do
        before do
          request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
        end

        it 'assigns the user id to the session' do
          get :omniauth
          expect(session[:user_id]).to eq(@player.id)
        end

        it 'redirects them to the root path' do
          get :omniauth
          expect(response).to redirect_to(root_path)
        end
      end

      context 'if they have not logged in before' do
        it 'creates the new user' do
          request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
          get :omniauth
          new_player = Player.find_by(provider: :github, uid: '1234')
          expect(new_player).to eq(Player.find(session[:user_id]))
        end

        it 'redirects when fails to create with credentials' do
          get :omniauth
          expect(response).to redirect_to(welcome_path)
        end

        it 'redirects to the tutorial page' do
          request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
          get :omniauth
          expect(response).to redirect_to(tutorial_path(1))
        end
      end
    end

    after do
      OmniAuth.config.test_mode = false
    end
  end
end
