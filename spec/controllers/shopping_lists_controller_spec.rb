# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShoppingListsController, type: :controller do
  before do
    ShoppingList.destroy_all
    Item.destroy_all
    Character.destroy_all
    Inventory.destroy_all

    Item.create(name: 'apple',
                description: 'crunchy, fresh from the tree',
                value: 2)

    Item.create(name: 'orange',
                description: 'tangy, fresh from the tree',
                value: 2)

    Item.create(name: 'wheat',
                description: 'grainy, fresh from the field',
                value: 1)

    Item.create(name: 'boots',
                description: 'sturdy and waterproof, fresh from the cobbler',
                value: 25)

    Item.create(name: 'map',
                description: 'detailed and reliable, fresh from the cartographer',
                value: 15)

    Item.create(name: 'fish',
                description: 'still floppin\' around, fresh from the ocean',
                value: 3)

    ShoppingList.create(item: Item.find_by(name: 'apple'),
                        level: 1,
                        quantity: 2)

    ShoppingList.create(item: Item.find_by(name: 'orange'),
                        level: 1,
                        quantity: 2)

    ShoppingList.create(item: Item.find_by(name: 'wheat'),
                        level: 1,
                        quantity: 5)

    ShoppingList.create(item: Item.find_by(name: 'boots'),
                        level: 2,
                        quantity: 2)

    ShoppingList.create(item: Item.find_by(name: 'map'),
                        level: 2,
                        quantity: 1)

    Player.create(name: 'Stella',
                  occupation: :farmer,
                  inventory_slots: 5,
                  balance: 0,
                  current_level: 1)

    Player.create(name: 'Victor',
                  occupation: :fisherman,
                  inventory_slots: 5,
                  balance: 0,
                  current_level: 2)

    Inventory.create(item: Item.find_by(name: 'apple'),
                     character: Player.find_by(name: 'Stella'),
                     quantity: 2)

    Inventory.create(item: Item.find_by(name: 'orange'),
                     character: Player.find_by(name: 'Stella'),
                     quantity: 1)

    Inventory.create(item: Item.find_by(name: 'boots'),
                     character: Player.find_by(name: 'Stella'),
                     quantity: 2)

    Inventory.create(item: Item.find_by(name: 'map'),
                     character: Player.find_by(name: 'Victor'),
                     quantity: 1)

    Inventory.create(item: Item.find_by(name: 'orange'),
                     character: Player.find_by(name: 'Victor'),
                     quantity: 2)

    Inventory.create(item: Item.find_by(name: 'boots'),
                     character: Player.find_by(name: 'Victor'),
                     quantity: 1)

    @apple_shopping_list = ShoppingList.find_by(item: Item.find_by(name: 'apple'))
  end

  describe 'index' do
    it 'shows all shopping lists' do
      shopping_lists = ShoppingList.all
      get :index
      expect(assigns(:shopping_lists)).to eq(shopping_lists)
    end
  end

  describe 'player_shopping_list' do
    it 'shows shopping list for the player\'s current level' do
      player_level = Player.first.current_level
      shopping_lists = ShoppingList.where(level: player_level)
      get :player_shopping_list
      expect(assigns(:level_shopping_lists)).to eq(shopping_lists)
    end
  end

  describe 'show' do
    it 'should show a given shopping list' do
      get :show, params: { id: @apple_shopping_list.id }
      expect(assigns(:shopping_list)).to eq(@apple_shopping_list)
    end
  end

  describe 'new' do
    it 'should create a new shopping list' do
      get :new
      expect(assigns(:shopping_list)).to be_a_new(ShoppingList)
    end
  end

  describe 'edit' do
    it 'should edit a given shopping list' do
      get :edit, params: { id: @apple_shopping_list.id }
      expect(assigns(:shopping_list)).to eq(@apple_shopping_list)
    end
  end

  describe 'create' do
    before(:each) do
      @shopping_list = { item: Item.find_by(name: 'fish'),
                         level: 1,
                         quantity: 3 }
      post :create, params: { shopping_list: @shopping_list }
    end
    it 'should create a new shopping list' do
      expect(assigns(:shopping_list)).to eq(ShoppingList.last)
      ShoppingList.last.destroy
    end

    it 'redirects to the shopping list details page' do
      expect(response).to redirect_to shopping_list_path(assigns(:shopping_list))
      ShoppingList.last.destroy
    end

    it 'flashes a notice' do
      expect(flash[:notice]).to match(/Shopping list was successfully created./)
      ShoppingList.last.destroy
    end
  end

  describe 'update' do
    before(:each) do
      @shopping_list = ShoppingList.create(item: Item.find_by(name: 'apple'),
                                           level: 1,
                                           quantity: 8)
      put :update, params: { id: @shopping_list.id,
                             shopping_list: { item: Item.find_by(name: 'fish'),
                                              level: 2,
                                              quantity: 3 } }
    end

    after(:each) do
      @shopping_list.destroy
    end

    it 'should change a shopping list' do
      expect(assigns(:shopping_list).item).to eq(Item.find_by(name: 'fish'))
    end

    it 'redirects to the shopping list details page' do
      expect(response).to redirect_to shopping_list_path(@shopping_list)
    end

    it 'flashes a notice' do
      expect(flash[:notice]).to match(/Shopping list was successfully updated./)
    end
  end

  describe 'destroy' do
    before do
      @shopping_list = ShoppingList.find_by(item: Item.find_by(name: 'apple'))
    end

    it 'should remove the shopping list' do
      delete :destroy, params: { id: @shopping_list.id }

      new_shopping_list = ShoppingList.find_by(id: @shopping_list)
      expect(new_shopping_list).to be_nil
    end

    it 'redirects to the shopping list index page' do
      delete :destroy, params: { id: @shopping_list.id }

      expect(response).to redirect_to shopping_lists_path
    end

    it 'flashes a notice' do
      delete :destroy, params: { id: @shopping_list.id }

      expect(flash[:notice]).to match(/Shopping list was successfully destroyed./)
    end
  end

  describe 'launch' do
    before do
      @stella = Player.find_by(name: 'Stella')
      @victor = Player.find_by(name: 'Victor')
      @orange_item = Item.find_by(name: 'orange')
      @wheat_item = Item.find_by(name: 'wheat')
    end

    it 'should not level up if shopping list not met' do
      post :launch, params: { id: @victor.id }
      expect(Player.find_by(name: 'Victor').current_level).to eq(2)
    end

    it 'should level up if player meets shopping list' do
      Inventory.find_by(item: @orange_item, character: @stella).update(quantity: 2)
      Inventory.create(item: @wheat_item, character: @stella, quantity: 5)

      post :launch, params: { id: @stella.id }
      expect(Player.find_by(name: 'Stella').current_level).to eq(2)
    end
  end
end
