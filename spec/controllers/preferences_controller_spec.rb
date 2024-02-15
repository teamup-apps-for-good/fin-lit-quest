# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PreferencesController, type: :controller do
  before do
    Item.destroy_all
    Character.destroy_all
    Preference.destroy_all

    Item.create(name: 'apple',
                description: 'crunchy, fresh from the tree',
                value: 2)

    Item.create(name: 'bread',
                description: 'yummy, fresh from the oven',
                value: 2)

    Character.create(name: 'Bobert',
                     occupation: :farmer,
                     inventory_slots: 20,
                     balance: 0,
                     current_level: 1)

    Character.create(name: 'Lightfoot',
                     occupation: :merchant,
                     inventory_slots: 20,
                     balance: 0,
                     current_level: 1)

    @bobert = Character.find_by(name: 'Bobert')
    @lightfoot = Character.find_by(name: 'Lightfoot')

    @apple_item = Item.find_by(name: 'apple')
    @bread_item = Item.find_by(name: 'bread')

    @pref = Preference.create(occupation: 'merchant',
                      item: @bread_item,
                      multiplier: 3)

  end

  describe 'index' do
    # rubycritic dislikes this, but we disagree because we need this test
    # it is human-readable and easy to maintain
    it 'shows all of preferences' do
      get :index
      expect(assigns(:preferences)).to eq(Preference.all)
    end
  end

  describe 'new' do
    it 'creates a new preference' do
      get :new
      expect(assigns(:preference)).to be_a_new(Preference)
    end
  end

  describe 'create' do
    before do
      @preference = { occupation: @bobert.occupation,
                      item_id: @apple_item.id,
                      multiplier: 1.5 }
      post :create, params: { preference: @preference }
    end

    after do
      Preference.last.destroy
    end

    it 'creates a new preference item' do
      expect(assigns(:preference)).to eq(Preference.last)
    end

    it 'redirects to the show preference page' do
      expect(response).to redirect_to preference_path(assigns(:preference))
    end

    it 'flashes a notice' do
      expect(flash[:notice]).to match(/Preference was successfully created./)
    end

    it 'renders the new page if the preference item is invalid' do
      post :create, params: { preference: { item: nil, occupation: nil, multiplier: -1 } }
      expect(response.status).to eq(422)
    end
  end

  describe 'update' do
    it 'updates a preference' do
      put :update, params: { id: @pref.id, preference: { multiplier: 3.5 } }
      expect(assigns(:preference).multiplier).to eq(3.5)
    end

    it 'redirects to the show preference page' do
      put :update, params: { id: @pref.id, preference: { multiplier: 3.5 } }
      expect(response).to redirect_to preference_path(assigns(:preference))
    end

    it 'flashes a notice' do
      put :update, params: { id: @pref.id, preference: { multiplier: 3.5 } }
      expect(flash[:notice]).to match(/Preference was successfully updated./)
    end

    it 'renders the edit page if the preference is invalid' do
      put :update, params: { id: @pref.id, preference: { multiplier: -1 } }
      expect(response.status).to be(422)
    end
  end

  describe 'destroy' do
    before do
      delete :destroy, params: { id: @pref.id }
    end

    it 'destroys an preference item' do
      expect(Preference.find_by(occupation: @lightfoot.occupation)).to be_nil
    end

    it 'redirects to the preference index' do
      expect(response).to redirect_to preferences_path
    end

    it 'flashes a notice' do
      expect(flash[:notice]).to match(/Preference was successfully destroyed./)
    end
  end
end
