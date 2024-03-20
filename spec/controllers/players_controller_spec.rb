# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayersController, type: :controller do
  before do
    Player.destroy_all

    Player.create!(name: 'Stella', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1,
                   email: 'test@test.com', provider: 'google-oauth2', uid: '1234')
    @stella = Player.find_by(name: 'Stella')
    session[:user_id] = @stella.id
  end

  describe 'create' do
    before(:each) do
      get :create,
          params: { player: { name: 'Jeremy', occupation: :merchant, inventory_slots: 5, balance: 10,
                              current_level: 1, email: 'test2@test.com', provider: 'google-oauth2', uid: '5678' } }
    end

    it 'should create a new character' do
      player = Player.find_by(name: 'Jeremy')
      expect(player).not_to be_nil
    end

    it 'should redirect to the player profile' do
      player = Player.find_by(name: 'Jeremy')
      expect(response).to redirect_to player_path(player)
    end

    it 'should show a flash message' do
      Player.find_by(name: 'Jeremy')
      expect(flash[:notice]).to match(/Your profile was successfully created. Welcome!/)
    end
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
    before do
      get :destroy, params: { id: @stella.id }
    end

    it 'should remove the player' do
      new_player = Player.find_by(id: @stella)
      expect(new_player).to be_nil
    end

    it 'flashes a notice' do
      expect(flash[:notice]).to match(/Your profile has been deleted./)
    end
  end

  # admin actions

  describe 'index' do
    # rubycritic dislikes this, but we disagree because we need this test
    # it is human-readable and easy to maintain
    it 'shows all players' do
      get :index
      expect(assigns(:players)).to eq(Player.all)
    end
  end

  describe 'new' do
    it 'creates a new player' do
      get :new
      expect(assigns(:player)).to be_a_new(Player)
    end
  end

  context 'starter items' do
    before do
      item1 = Item.create!(name: 'test item', description: 'test', value: 1)
      item2 = Item.create!(name: 'test item 2', description: 'test', value: 1)

      @si1 = StarterItem.create!({ item: item1, quantity: 1 })
      @si2 = StarterItem.create!({ item: item2, quantity: 2 })
    end

    after do
      StarterItem.destroy_all
      Inventory.destroy_all
      Item.destroy_all
    end

    describe 'adding starter items' do
      it 'adds all starting items to a new player' do
        get :create,
            params: { player: { name: 'Jeremy', occupation: :merchant, inventory_slots: 5, balance: 10,
                                current_level: 1, email: 'test2@test.com', provider: 'google-oauth2', uid: '5678' } }
        p = Player.find_by(name: 'Jeremy')

        inv1 = Inventory.find_by(item: @si1.item, character: p)
        expect(inv1).not_to be_nil
        expect(inv1.quantity).to eq(1)
        inv2 = Inventory.find_by(item: @si2.item, character: p)
        expect(inv2).not_to be_nil
        expect(inv2.quantity).to eq(2)
      end
    end
  end
end
