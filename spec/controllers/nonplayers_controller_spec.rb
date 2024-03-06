# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NonplayersController, type: :controller do
  before do
    Nonplayer.destroy_all
    Item.destroy_all

    Item.create(name: 'apple',
                description: 'crunchy, fresh from the tree',
                value: 2)

    Item.create(name: 'fish',
                description: 'still floppin\' around, fresh from the ocean',
                value: 3)
    Item.create(name: 'orange',
                description: 'test description',
                value: 5)
    Item.create(name: 'wheat',
                description: 'test description',
                value: 3)

    Nonplayer.create!({ name: 'Ritchey',
                        occupation: 'merchant',
                        inventory_slots: 5,
                        balance: 0,
                        personality: :enthusiastic,
                        dialogue_content: 'howdy all',
                        current_level: 1,
                        item_to_accept: Item.find_by(name: 'apple'),
                        item_to_offer: Item.find_by(name: 'orange'),
                        quantity_to_accept: 2,
                        quantity_to_offer: 5 })

    @ritchey = Nonplayer.find_by(name: 'Ritchey')

    @user = Player.create!(name: 'Test User', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1,
                           email: 'test@test.com', provider: 'google-oauth2', uid: '1234')
    session[:user_id] = @user.id
  end

  describe 'index' do
    # rubycritic dislikes this, but we disagree because we need this test
    # it is human-readable and easy to maintain
    it 'all non players should be visible' do
      get :index
      expect(assigns(:nonplayers)).to eq(Nonplayer.all)
    end
  end

  describe 'show' do
    # rubycritic dislikes this, but we disagree because we need this test
    # it is human-readable and easy to maintain
    it 'should show a given nonplayer' do
      get :show, params: { id: @ritchey.id }
      expect(assigns(:nonplayer)).to eq(@ritchey)
    end
  end

  # admin actions

  describe 'update' do
    before do
      put :update, params: { id: @ritchey.id,
                             nonplayer: { occupation: :merchant,
                                          item_to_offer: @ritchey.item_to_offer,
                                          item_to_accept: @ritchey.item_to_accept } }
    end

    it 'should change a nonplayer' do
      expect(assigns(:nonplayer).occupation).to eq('merchant')
    end

    it 'redirects to the nonplayer details page' do
      expect(response).to redirect_to nonplayer_path(@ritchey)
    end

    it 'flashes a notice' do
      expect(flash[:notice]).to match(/Ritchey was successfully updated./)
    end
  end

  describe 'destroy' do
    before do
      delete :destroy, params: { id: @ritchey.id }
    end
    it 'should remove the nonplayer' do
      new_nonplayer = Nonplayer.find_by(id: @ritchey)
      expect(new_nonplayer).to be_nil
    end

    it 'redirects to the home page' do
      expect(response).to redirect_to nonplayers_path
    end

    it 'flashes a notice' do
      expect(flash[:notice]).to match(/Ritchey was successfully deleted./)
    end
  end

  describe 'create' do
    before(:each) do
      post :create,
           params: { nonplayer: { name: 'Jeremy',
                                  occupation: 'merchant',
                                  inventory_slots: 5,
                                  balance: 10,
                                  personality: 'enthusiastic',
                                  item_to_accept: Item.find_by(name: 'apple'),
                                  item_to_offer: Item.find_by(name: 'orange'),
                                  quantity_to_accept: 2,
                                  quantity_to_offer: 5,
                                  dialogue_content: 'Jeremy',
                                  current_level: 1 } }

      @jeremy = Nonplayer.find_by(name: 'Jeremy')
    end

    it 'should create a new nonplayer' do
      expect(@jeremy).not_to be_nil
    end

    it 'should redirect to the nonplayer profile' do
      expect(response).to redirect_to nonplayer_path(@jeremy)
    end

    it 'should show a flash message' do
      expect(flash[:notice]).to match(/Jeremy was successfully created./)
    end
  end

  describe 'create without item' do
    it 'should not create a new nonplayer' do
      post :create,
           params: { nonplayer: { name: 'Jeremy',
                                  occupation: 'merchant',
                                  inventory_slots: 5,
                                  balance: 10,
                                  personality: 'enthusiastic',
                                  item_to_accept: Item.last.id + 1,
                                  item_to_offer: Item.last.id + 1,
                                  quantity_to_accept: 2,
                                  quantity_to_offer: 5,
                                  dialogue_content: 'Jeremy',
                                  current_level: 1 } }
      @jeremy = Nonplayer.find_by(name: 'Jeremy')
      expect(@jeremy).to be_nil
    end
  end

  describe 'new' do
    it 'should create a new nonplayer' do
      get :new
      expect(assigns(:nonplayer)).to be_a(Nonplayer)
    end
  end
end
