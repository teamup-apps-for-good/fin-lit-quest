# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CharactersController, type: :controller do
  before do
    @player = create(:character, :player)
    allow(Player).to receive(:first).and_return(@player)

    @user = Player.create!(name: 'Test User', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1,
                           email: 'test@test.com', provider: 'google-oauth2', uid: '1234', admin: true)
    Item.create(name: 'wheat',
                description: 'test description',
                value: 3)

    @nonplayer = Nonplayer.create!({ name: 'Ritchey',
                                     occupation: 'merchant',
                                     inventory_slots: 5,
                                     balance: 0,
                                     personality: :enthusiastic,
                                     dialogue_content: 'howdy all',
                                     current_level: 1,
                                     item_to_accept: Item.find_by(name: 'wheat'),
                                     item_to_offer: Item.find_by(name: 'wheat'),
                                     quantity_to_accept: 2,
                                     quantity_to_offer: 5 })
    session[:user_id] = @user.id
  end

  describe 'New Character' do
    let(:valid_attributes) do
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

  describe 'Admin actions' do
    before do
      @user.admin = false
      @user.save!
    end

    %i[show profile inventory].each do |tag|
      it 'allows the current player to view themselves' do
        get tag, params: { id: session[:user_id] }
        expect(response).to be_successful
      end

      it 'allows the player to view nonplayers' do
        get tag, params: { id: @nonplayer.id }
        expect(response).to be_successful
      end

      it 'does not allow players to view other players' do
        character = Player.create!(name: 'Test User', occupation: :farmer,
                                   inventory_slots: 5, balance: 0, current_level: 1,
                                   email: 'test@test.com', provider: 'google-oauth2', uid: '1235', admin: true)
        get tag, params: { id: character.id }
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to match(/You do not have permission to access this path./)
      end

      it 'allows admins' do
        @user.admin = true
        @user.save!
        character = Player.create!(name: 'Test User', occupation: :farmer,
                                   inventory_slots: 5, balance: 0, current_level: 1,
                                   email: 'test@test.com', provider: 'google-oauth2', uid: '1235', admin: true)
        get tag, params: { id: character.id }
        expect(response).to be_successful
      end
    end
  end

  describe 'going up to talk to an npc in town' do
    before do
      Item.create!(name: 'apple', description: 'crunchy, fresh from the tree', value: 2)
      Item.create!(name: 'orange', description: 'test description', value: 5)
      Nonplayer.create!(name: 'Lightfoot', occupation: :comedian, inventory_slots: 5, balance: 0, personality: :dad,
                        dialogue_content: 'goodbye', current_level: 1,
                        item_to_accept: Item.find_by(name: 'apple'), item_to_offer: Item.find_by(name: 'orange'),
                        quantity_to_accept: 2, quantity_to_offer: 5)

      @nonplayer = Nonplayer.find_by(name: 'Lightfoot')
    end
    it 'should show the profile with some attributes of the npc' do
      get :profile, params: { id: @nonplayer.id }
      expect(assigns(:character)).to eq(@nonplayer)
    end
    it 'should show the inventory of the npc' do
      get :inventory, params: { id: @nonplayer.id }
      expect(assigns(:inventories)).to eq(@nonplayer.inventories)
    end
  end

  describe 'POST #advance_day' do
    it 'advances the day for the first player and redirects with a notice' do
      expect(TimeAdvancementHelper).to receive(:increment_day).with(@user)
      post :advance_day
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to match(/Moved to the next day./)
    end
  end

  describe 'POST #launch_to_new_era' do
    it 'launches to a new era for the first player and redirects with a notice' do
      expect(TimeAdvancementHelper).to receive(:increment_era).with(@user)
      post :launch_to_new_era
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to match(/Moved to the next Era./)
    end
  end

  context 'when the user cannot afford expenses' do
    before do
      allow(Expense).to receive(:advance_and_deduct?).and_return(false)
    end

    context 'and it is past hour 10' do
      before do
        @user.update(hour: 11) # Ensure hour is greater than 10
      end

      it 'resets the user level to 0 and redirects to the game over page' do
        post :advance_day

        expect(@user.reload.current_level).to eq(0)
        expect(response).to redirect_to(game_over_path)
        expect(flash[:alert]).to eq("Game Over: You can't afford to pay your expenses and have run out of time.")
      end
    end

    context 'and it is before hour 10' do
      it 'does not change the user level and redirects with a notice' do
        allow(@user).to receive(:hour).and_return(9)
        expect(@user).not_to receive(:update)

        post :advance_day

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to match(/You can't afford to pay your expenses yet!/)
      end
    end
  end
end
