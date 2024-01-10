# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayersController, type: :controller do
  before do
    Player.destroy_all

    Player.create(name: 'Stella', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1)
  end

  describe 'show' do
    it 'should show a given player' do
      player = Player.find_by(name: 'Stella')
      get :show, params: { id: player.id }
      expect(assigns(:player)).to eq(player)
    end
  end

  describe 'update' do
    it 'should change a player' do
      player = Player.find_by(name: 'Stella')
      get :update, params: { id: player.id, player: { occupation: :merchant } }

      expect(assigns(:player).occupation).to eq('merchant')
    end

    it 'redirects to the player details page' do
      player = Player.find_by(name: 'Stella')
      get :update, params: { id: player.id, player: { occupation: :merchant } }

      expect(response).to redirect_to player_path(player)
    end

    it 'flashes a notice' do
      player = Player.find_by(name: 'Stella')
      get :update, params: { id: player.id, player: { occupation: :merchant } }

      expect(flash[:notice]).to match(/Your profile has been updated./)
    end
  end

  describe 'destroy' do
    it 'should remove the player' do
      player = Player.find_by(name: 'Stella')
      get :destroy, params: { id: player.id }

      new_player = Player.find_by(id: player)
      expect(new_player).to be_nil
    end

    it 'redirects to the home page' do
      player = Player.find_by(name: 'Stella')
      get :destroy, params: { id: player.id }

      expect(response).to redirect_to root_path
    end

    it 'flashes a notice' do
      player = Player.find_by(name: 'Stella')
      get :destroy, params: { id: player.id }

      expect(flash[:notice]).to match(/Your profile has been deleted./)
    end
  end

  # admin actions

  describe 'index' do
    it 'shows all players' do
      players = Player.all
      get :index
      expect(assigns(:players)).to eq(players)
    end
  end
end
