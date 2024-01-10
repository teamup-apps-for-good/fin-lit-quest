# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  before do
    Item.destroy_all

    Item.create(name: 'apple',
                description: 'crunchy, fresh from the tree',
                value: 2)

    Item.create(name: 'fish',
                description: 'still floppin\' around, fresh from the ocean',
                value: 3)

    Item.create(name: 'wheat',
                description: 'grainy, fresh from the field',
                value: 1)

    Item.create(name: 'bread',
                description: 'yummy, fresh from the oven',
                value: 2)
  end

  describe 'index' do
    it 'shows all of the items' do
      get :index
      expect(assigns(:items)).to eq(Item.all)
    end
  end

    describe 'new' do
        it 'creates a new item' do
            get :new
            expect(assigns(:item)).to be_a_new(Item)
        end
    end

    describe 'create' do
        it 'creates a new item' do
            get :create, params: { item: { name: 'orange', description: 'juicy, fresh from the tree', value: 2 } }
            expect(assigns(:item)).to eq(Item.last)
            Item.last.destroy
        end

        it 'redirects to the show item page' do
            get :create, params: { item: { name: 'potato', description: 'starchy, fresh from the ground', value: 1 } }
            expect(response).to redirect_to item_path(Item.last)
            Item.last.destroy
        end

        it 'flashes a notice' do
            get :create, params: { item: { name: 'grapes', description: 'sweet, fresh from the vine', value: 2 } }
            expect(flash[:notice]).to match(/Item was successfully created./)
            Item.last.destroy
        end

        it 'renders the new item page if the item is invalid' do
            get :create, params: { item: { name: nil, description: nil, value: nil } }
            expect(response).to render_template(:new)
        end
    end

    describe 'update' do
        it 'updates an item' do
            item = Item.find_by(name: 'apple')
            get :update, params: { id: item.id, item: { description: 'mmm, red apple' } }
            expect(assigns(:item).description).to eq('mmm, red apple')
        end

        it 'redirects to the show item page' do
            item = Item.find_by(name: 'fish')
            get :update, params: { id: item.id, item: { description: 'hrmm, this needs to be cooked' } }
            expect(response).to redirect_to item_path(item)
        end

        it 'flashes a notice' do
            item = Item.find_by(name: 'wheat')
            get :update, params: { id: item.id, item: { description: 'mmm, need me some bread' } }
            expect(flash[:notice]).to match(/Item was successfully updated./)
        end

        it 'renders the edit item page if the item is invalid' do
            item = Item.find_by(name: 'bread')
            get :update, params: { id: item.id, item: { name: nil, description: nil, value: -1 } }
            expect(response).to render_template(:edit)
        end
    end

    describe 'destroy' do
        it 'destroys an item' do
            item = Item.find_by(name: 'apple')
            get :destroy, params: { id: item.id }
            expect(Item.find_by(name: 'apple')).to be_nil
        end

        it 'redirects to the index page' do
            item = Item.find_by(name: 'fish')
            get :destroy, params: { id: item.id }
            expect(response).to redirect_to items_path
        end

        it 'flashes a notice' do
            item = Item.find_by(name: 'wheat')
            get :destroy, params: { id: item.id }
            expect(flash[:notice]).to match(/Item was successfully destroyed./)
        end
    end
end