# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CharactersController, type: :controller do
  describe 'Admin access' do
    let(:valid_attributes) do
      # Define valid attributes for your character model
      { name: 'Test Character', occupation: 'Test Occupation', inventory_slots: 10, balance: 100, type: 'Character' }
    end

    describe 'GET #index' do
      it 'returns a success response' do
        Character.create! valid_attributes
        get :index, params: {}
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        character = Character.create! valid_attributes
        get :show, params: { id: character.to_param }
        expect(response).to be_successful
      end
    end
  end
end
