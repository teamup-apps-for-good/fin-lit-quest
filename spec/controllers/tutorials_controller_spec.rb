# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TutorialsController, type: :controller do
  before do
    Player.destroy_all

    @stella = Player.create!(name: 'Stella', occupation: 'farmer', inventory_slots: 5, balance: 0, current_level: 1,
                            email: 'test@test.com', provider: 'google_oauth2', uid: '1234', day: 1, hour: 1)
    
    @bill = Player.create!(name: 'Bill', occupation: 'farmer', inventory_slots: 5, balance: 0, current_level: 2,
                            email: 'test@test.com', provider: 'google_oauth2', uid: '4321', day: 1, hour: 1)
  end
  
  describe 'GET #show' do
    context 'when user on level 1 is logged in' do
      before do
        session[:user_id] = @stella.id
      end

      it 'returns the current tutorial level' do
        get :show
        expect(assigns(:tutorial_level)).to eq(@stella.current_level)
        expect(assigns(:last_page)).to eq(6)
      end

      it 'correctly sets @page when specified' do
        get :show, params: { page: 3 }
        expect(assigns(:page)).to eq(3)
      end

      it 'assigns the correct last page for tutorial level' do
        get :show
        expect(assigns(:last_page)).to eq(6)
      end
    end

    context 'when user on level 2 is logged in' do
      before do
        session[:user_id] = @bill.id
      end

      it 'returns the current tutorial level' do
        get :show
        expect(assigns(:tutorial_level)).to eq(@bill.current_level)
        expect(assigns(:last_page)).to eq(7)  # Assuming level 2 has 7 pages
      end

      it 'assigns the correct last page for tutorial level' do
        get :show
        expect(assigns(:last_page)).to eq(7)
      end
    end

    context 'when user is not logged in' do
      before do
        session[:user_id] = nil
      end

      it 'does not set tutorial level' do
        get :show
        expect(assigns(:tutorial_level)).to be_nil
      end
    end
  end
end
