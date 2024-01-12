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

    npcs = [{ name: 'Ritchey', occupation: :merchant, inventory_slots: 5, balance: 0, personality: :enthusiastic,
              dialogue_content: 'hello',
              current_level: 1,
              item_to_accept: Item.find_by(name: 'apple'),
              item_to_offer: Item.find_by(name: 'orange'),
              quantity_to_accept: 2,
              quantity_to_offer: 5 },
            { name: 'Lightfoot', occupation: :comedian, inventory_slots: 5, balance: 0, personality: :dad,
              dialogue_content: 'goodbye',
              current_level: 1,
              item_to_accept: Item.find_by(name: 'apple'),
              item_to_offer: Item.find_by(name: 'orange'),
              quantity_to_accept: 2,
              quantity_to_offer: 5 }]

    npcs.each { |npc| Nonplayer.create!(npc) }
  end

  describe 'index' do
    it 'shows all non nonplayers' do
      nonplayers = Nonplayer.all
      get :index
      expect(assigns(:nonplayers)).to eq(nonplayers)
    end
  end

  describe 'show' do
    it 'should show a given nonplayer' do
      nonplayer = Nonplayer.find_by(name: 'Ritchey')
      get :show, params: { id: nonplayer.id }
      expect(assigns(:nonplayer)).to eq(nonplayer)
    end
  end

  # admin actions

  describe 'update' do
    it 'should change a nonplayer' do
      nonplayer = Nonplayer.find_by(name: 'Ritchey')
      put :update, params: { id: nonplayer.id,
                             nonplayer: { occupation: :merchant,
                                          item_to_offer: nonplayer.item_to_offer,
                                          item_to_accept: nonplayer.item_to_accept } }

      expect(assigns(:nonplayer).occupation).to eq('merchant')
    end

    it 'redirects to the nonplayer details page' do
      nonplayer = Nonplayer.find_by(name: 'Ritchey')
      put :update, params: { id: nonplayer.id,
                             nonplayer: { occupation: :merchant,
                                          item_to_offer: nonplayer.item_to_offer,
                                          item_to_accept: nonplayer.item_to_accept } }

      expect(response).to redirect_to nonplayer_path(nonplayer)
    end

    it 'flashes a notice' do
      nonplayer = Nonplayer.find_by(name: 'Ritchey')
      put :update, params: { id: nonplayer.id,
                             nonplayer: { occupation: :merchant,
                                          item_to_offer: nonplayer.item_to_offer,
                                          item_to_accept: nonplayer.item_to_accept } }

      expect(flash[:notice]).to match(/Ritchey was successfully updated./)
    end
  end

  describe 'destroy' do
    it 'should remove the nonplayer' do
      nonplayer = Nonplayer.find_by(name: 'Ritchey')
      delete :destroy, params: { id: nonplayer.id }

      new_nonplayer = Nonplayer.find_by(id: nonplayer)
      expect(new_nonplayer).to be_nil
    end

    it 'redirects to the home page' do
      nonplayer = Nonplayer.find_by(name: 'Ritchey')
      delete :destroy, params: { id: nonplayer.id }

      expect(response).to redirect_to nonplayers_path
    end

    it 'flashes a notice' do
      nonplayer = Nonplayer.find_by(name: 'Ritchey')
      delete :destroy, params: { id: nonplayer.id }

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
    end

    it 'should create a new nonplayer' do
      nonplayer = Nonplayer.find_by(name: 'Jeremy')
      expect(nonplayer).not_to be_nil
    end

    it 'should redirect to the nonplayer profile' do
      nonplayer = Nonplayer.find_by(name: 'Jeremy')
      expect(response).to redirect_to nonplayer_path(nonplayer)
    end

    it 'should show a flash message' do
      expect(flash[:notice]).to match(/Jeremy was successfully created./)
    end
  end
end
