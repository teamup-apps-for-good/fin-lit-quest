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

        Character.create(name: "Stella",
                         occupation: :farmer,
                         inventory_slots: 20,
                         balance: 0,
                         current_level: 1)

        Character.create(name: "Lightfoot",
                         occupation: :merchant,
                         inventory_slots: 20,
                         balance: 0,
                         current_level: 1)

        Inventory.create(item: (Item.find_by(name: 'apple')).id,
                         owner_id: (Character.find_by(name: 'Stella')).id,
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
        it 'creates a new inventory item' do
            get :create, params: { inventory: { item: (Item.find_by(name: 'apple')).id,
                                                owner_id: (Character.find_by(name: 'Lightfoot')).id,
                                                quantity: 5 } }
            expect(assigns(:inventory)).to eq(Inventory.last)
            Inventory.last.destroy
        end

        it 'redirects to the show inventory page' do
            get :create, params: { inventory: { item: (Item.find_by(name: 'apple')).id,
                                                owner_id: (Character.find_by(name: 'Lightfoot')).id,
                                                quantity: 5 } }
            expect(response).to redirect_to inventory_path(assigns(:inventory))
            Inventory.last.destroy
        end

        it 'flashes a notice' do
            get :create, params: { inventory: { item: (Item.find_by(name: 'apple')).id,
                                                owner_id: (Character.find_by(name: 'Lightfoot')).id,
                                                quantity: 5 } }
            expect(flash[:notice]).to match(/Inventory was successfully created./)
            Inventory.last.destroy
        end
    end

    describe 'update' do
        it 'updates an inventory item' do
            inventory_item = Inventory.create(item: (Item.find_by(name: 'fish')).id,
                                              owner_id: (Character.find_by(name: 'Stella')).id,
                                              quantity: 5)
            get :update, params: { id: inventory_item.id, inventory: { quantity: 1 } }
            expect(assigns(:inventory).quantity).to eq(1)
            inventory_item.destroy
        end

        it 'redirects to the show inventory page' do
            inventory_item = Inventory.create(item: (Item.find_by(name: 'fish')).id,
                                              owner_id: (Character.find_by(name: 'Stella')).id,
                                              quantity: 5)
            get :update, params: { id: inventory_item.id, inventory: { quantity: 1 } }
            expect(response).to redirect_to inventory_path(assigns(:inventory))
            inventory_item.destroy
        end

        it 'flashes a notice' do
            inventory_item = Inventory.create(item: (Item.find_by(name: 'fish')).id,
                                              owner_id: (Character.find_by(name: 'Stella')).id,
                                              quantity: 5)
            get :update, params: { id: inventory_item.id, inventory: { quantity: 1 } }
            expect(flash[:notice]).to match(/Inventory was successfully updated./)
            inventory_item.destroy
        end
    end

    describe 'destroy' do
        it 'destroys an inventory item' do
            inventory_item = Inventory.create(item: (Item.find_by(name: 'fish')).id,
                                              owner_id: (Character.find_by(name: 'Lightfoot')).id,
                                              quantity: 1)
            delete :destroy, params: { id: inventory_item.id }
            expect(Inventory.find_by(id: inventory_item.id)).to be_nil
        end

        it 'redirects to the inventory index' do
            inventory_item = Inventory.create(item: (Item.find_by(name: 'fish')).id,
                                              owner_id: (Character.find_by(name: 'Lightfoot')).id,
                                              quantity: 1)
            delete :destroy, params: { id: inventory_item.id }
            expect(response).to redirect_to inventories_path
        end

        it 'flashes a notice' do
            inventory_item = Inventory.create(item: (Item.find_by(name: 'fish')).id,
                                              owner_id: (Character.find_by(name: 'Lightfoot')).id,
                                              quantity: 1)
            delete :destroy, params: { id: inventory_item.id }
            expect(flash[:notice]).to match(/Inventory was successfully destroyed./)
        end
    end
end
