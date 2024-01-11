# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NonplayersController, type: :controller do
  before do
    Nonplayer.destroy_all

    npcs = [{ name: 'Ritchey', occupation: :merchant, inventory_slots: 5, balance: 0, personality: :enthusiastic,
              dialogue_content: 'hello' },
            { name: 'Lightfoot', occupation: :comedian, inventory_slots: 5, balance: 0, personality: :dad,
              dialogue_content: 'goodbye' }]

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
      get :update, params: { id: nonplayer.id, nonplayer: { occupation: :merchant } }

      expect(assigns(:nonplayer).occupation).to eq('merchant')
    end

    it 'redirects to the nonplayer details page' do
      nonplayer = Nonplayer.find_by(name: 'Ritchey')
      get :update, params: { id: nonplayer.id, nonplayer: { occupation: :merchant } }

      expect(response).to redirect_to nonplayer_path(nonplayer)
    end

    it 'flashes a notice' do
      nonplayer = Nonplayer.find_by(name: 'Ritchey')
      get :update, params: { id: nonplayer.id, nonplayer: { occupation: :merchant } }

      expect(flash[:notice]).to match(/Ritchey was successfully updated./)
    end
  end

  describe 'destroy' do
    it 'should remove the nonplayer' do
      nonplayer = Nonplayer.find_by(name: 'Ritchey')
      get :destroy, params: { id: nonplayer.id }

      new_nonplayer = Nonplayer.find_by(id: nonplayer)
      expect(new_nonplayer).to be_nil
    end

    it 'redirects to the home page' do
      nonplayer = Nonplayer.find_by(name: 'Ritchey')
      get :destroy, params: { id: nonplayer.id }

      expect(response).to redirect_to nonplayers_path
    end

    it 'flashes a notice' do
      nonplayer = Nonplayer.find_by(name: 'Ritchey')
      get :destroy, params: { id: nonplayer.id }

      expect(flash[:notice]).to match(/Ritchey was successfully deleted./)
    end
  end

  describe 'create' do
    it 'should create a new nonplayer' do
      get :create,
          params: { nonplayer: { name: 'Jeremy', occupation: :merchant, inventory_slots: 5, balance: 10,
                                 personality: :enthusiastic } }
      nonplayer = Nonplayer.find_by(name: 'Jeremy')
      expect(nonplayer).not_to be_nil
    end

    it 'should redirect to the nonplayer profile' do
      get :create,
          params: { nonplayer: { name: 'Jeremy', occupation: :merchant, inventory_slots: 5, balance: 10,
                                 personality: :enthusiastic } }
      nonplayer = Nonplayer.find_by(name: 'Jeremy')
      expect(response).to redirect_to nonplayer_path(nonplayer)
    end

    it 'should show a flash message' do
      get :create,
          params: { nonplayer: { name: 'Jeremy', occupation: :merchant, inventory_slots: 5, balance: 10,
                                 personality: :enthusiastic } }

      expect(flash[:notice]).to match(/Jeremy was successfully created./)
    end
  end
end
