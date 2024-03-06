# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameplaysController, type: :controller do
  before do
    @current_user = Player.create(name: 'Stella',
                                  occupation: :farmer,
                                  inventory_slots: 20,
                                  balance: 0,
                                  current_level: 1,
                                  email: 'test@test.com',
                                  provider: 'example-provider',
                                  uid: '1234')
    Nonplayer.create(name: 'test', current_level: 1)
    @dead_player = Player.create(name: 'Dead',
                                 occupation: :farmer,
                                 inventory_slots: 20,
                                 balance: 0,
                                 current_level: 0,
                                 email: 'wdadw@dwad.com',
                                 provider: 'example-provider',
                                 uid: '1235')
    session[:user_id] = @current_user.id
  end

  after do
    @current_user.destroy
    Nonplayer.destroy_all
  end

  describe 'town' do
    it 'should give the npcs in this world' do
      get :town
      expect(assigns(:nonplayers)).to eq(Nonplayer.where(current_level: @current_user.current_level))
    end
  end

  describe 'check_game_over' do
    before do
      session[:user_id] = @dead_player.id
    end

    after do
      session[:user_id] = @current_user.id
    end
    it 'should redirect to game_over_path if current_level is zero' do
      get :town
      expect(response).to redirect_to(game_over_path)
    end
  end

  describe 'restart' do
    it 'should restart the game' do
      get :restart
      @current_user.reload
      expect(@current_user.current_level).to eq(1)
      expect(@current_user.balance).to eq(0)
      expect(@current_user.day).to eq(1)
      expect(@current_user.hour).to eq(1)
      expect(response).to redirect_to(root_path)
    end
  end
end
