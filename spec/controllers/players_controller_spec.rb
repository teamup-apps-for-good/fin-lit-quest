# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayersController, type: :controller do
  before do
    Player.destroy_all

    Player.create(name: 'Stella', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1)
  end

  describe 'Player actions' do
    it 'should show player' do
      player = Player.find_by(name: 'Stella')
      get :show, params: { id: player.id }
      expect(assigns(:player)).to eq(player)
    end
  end
end
