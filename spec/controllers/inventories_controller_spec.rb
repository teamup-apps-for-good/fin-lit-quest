# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InventoriesController, type: :controller do
  before do
    Item.destroy_all
    Character.destroy_all
    Inventory.destroy_all

    Item.create(name: 'apple',
                description: 'crunchy, fresh from the tree',
                value: 2)

    Item.create(name: 'fish',
                description: 'still floppin\' around, fresh from the ocean',
                value: 3)

    Character.create(name: 'Stella',
                     occupation: :farmer,
                     inventory_slots: 20,
                     balance: 0,
                     current_level: 1)

    Character.create(name: 'Lightfoot',
                     occupation: :merchant,
                     inventory_slots: 20,
                     balance: 0,
                     current_level: 1)

    Inventory.create(item: Item.find_by(name: 'apple'),
                     character: Character.find_by(name: 'Stella'),
                     quantity: 5)
  end

  describe 'index' do
    it 'shows all of inventory' do
      get :index
      expect(assigns(:inventories)).to eq(Inventory.all)
    end
  end

  describe 'new' do
    it 'creates a new inventory' do
      get :new
      expect(assigns(:inventory)).to be_a_new(Inventory)
    end
  end

  describe 'create' do
    before(:each) do
      @inventory = { item: Item.find_by(name: 'apple').name,
                     character: Character.find_by(name: 'Lightfoot').name,
                     quantity: 5 }
      post :create, params: { inventory: @inventory }
    end
    it 'creates a new inventory item' do
      expect(assigns(:inventory)).to eq(Inventory.last)
      Inventory.last.destroy
    end

    it 'redirects to the show inventory page' do
      expect(response).to redirect_to inventory_path(assigns(:inventory))
      Inventory.last.destroy
    end

    it 'flashes a notice' do
      expect(flash[:notice]).to match(/Inventory was successfully created./)
      Inventory.last.destroy
    end

    it 'renders the new page if the inventory item is invalid' do
      post :create, params: { inventory: { item: nil, character: nil, quantity: -1 } }
      expect(response.status).to eq(422)
    end
  end

  describe 'update' do
    it 'updates an inventory item' do
      inventory_item = Inventory.create(item: Item.find_by(name: 'fish'),
                                        character: Character.find_by(name: 'Stella'),
                                        quantity: 5)
      put :update, params: { id: inventory_item.id, inventory: { quantity: 1 } }
      expect(assigns(:inventory).quantity).to eq(1)
      inventory_item.destroy
    end

    it 'redirects to the show inventory page' do
      inventory_item = Inventory.create(item: Item.find_by(name: 'fish'),
                                        character: Character.find_by(name: 'Stella'),
                                        quantity: 5)
      put :update, params: { id: inventory_item.id, inventory: { quantity: 1 } }
      expect(response).to redirect_to inventory_path(assigns(:inventory))
      inventory_item.destroy
    end

    it 'flashes a notice' do
      inventory_item = Inventory.create(item: Item.find_by(name: 'fish'),
                                        character: Character.find_by(name: 'Stella'),
                                        quantity: 5)
      put :update, params: { id: inventory_item.id, inventory: { quantity: 1 } }
      expect(flash[:notice]).to match(/Inventory was successfully updated./)
      inventory_item.destroy
    end

    it 'renders the edit page if the inventory item is invalid' do
      inventory_item = Inventory.create(item: Item.find_by(name: 'fish'),
                                        character: Character.find_by(name: 'Stella'),
                                        quantity: 5)
      put :update, params: { id: inventory_item.id, inventory: { item: nil, character: nil, quantity: -1 } }
      expect(response).to redirect_to edit_inventory_path(inventory_item)
      inventory_item.destroy
    end
  end

  describe 'destroy' do
    it 'destroys an inventory item' do
      inventory_item = Inventory.create(item: Item.find_by(name: 'fish'),
                                        character: Character.find_by(name: 'Lightfoot'),
                                        quantity: 1)
      delete :destroy, params: { id: inventory_item.id }
      expect(Inventory.find_by(id: inventory_item.id)).to be_nil
    end

    it 'redirects to the inventory index' do
      inventory_item = Inventory.create(item: Item.find_by(name: 'fish'),
                                        character: Character.find_by(name: 'Lightfoot'),
                                        quantity: 1)
      delete :destroy, params: { id: inventory_item.id }
      expect(response).to redirect_to inventories_path
    end

    it 'flashes a notice' do
      inventory_item = Inventory.create(item: Item.find_by(name: 'fish'),
                                        character: Character.find_by(name: 'Lightfoot'),
                                        quantity: 1)
      delete :destroy, params: { id: inventory_item.id }
      expect(flash[:notice]).to match(/Inventory was successfully destroyed./)
    end
  end
end
