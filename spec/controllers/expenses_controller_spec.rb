# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
  before do
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

    @expense = Expense.create(frequency: 'day',
                              number: '1',
                              item: @bread_item,
                              quantity: 3)

    @user = Player.create!(name: 'Test User', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1,
                           email: 'test@test.com', provider: 'google-oauth2', uid: '1234')

    session[:user_id] = @user.id
  end

  after do
    Expense.destroy_all
    Item.destroy_all
    Character.destroy_all
  end

  describe 'index' do
    it 'shows all of expenses' do
      get :index
      expect(assigns(:expenses)).to eq(Expense.all)
    end
  end

  describe 'new' do
    it 'creates a new expense' do
      get :new
      expect(assigns(:expense)).to be_a_new(Expense)
    end
  end

  describe 'create' do
    before do
      @expense_params = { frequency: 'day',
                          number: '1',
                          item_id: @apple_item.id,
                          quantity: 2 }
      post :create, params: { expense: @expense_params }
    end

    after do
      Expense.last.destroy
    end

    it 'creates a new expense item' do
      expect(assigns(:expense)).to eq(Expense.last)
    end

    it 'redirects to the show expense page' do
      expect(response).to redirect_to expense_path(assigns(:expense))
    end

    it 'flashes a notice' do
      expect(flash[:notice]).to match(/Expense was successfully created./)
    end

    it 'renders the new page if the expense item is invalid' do
      post :create, params: { expense: { quantity: -1 } }
      expect(response.status).to eq(422)
    end
  end

  describe 'update' do
    it 'updates an expense' do
      put :update, params: { id: @expense.id, expense: { quantity: 4 } }
      expect(assigns(:expense).quantity).to eq(4)
    end

    it 'redirects to the show expense page' do
      put :update, params: { id: @expense.id, expense: { quantity: 4 } }
      expect(response).to redirect_to expense_path(assigns(:expense))
    end

    it 'flashes a notice' do
      put :update, params: { id: @expense.id, expense: { quantity: 4 } }
      expect(flash[:notice]).to match(/Expense was successfully updated./)
    end

    it 'renders the edit page if the expense is invalid' do
      put :update, params: { id: @expense.id, expense: { quantity: -1 } }
      expect(response.status).to be(422)
    end
  end

  describe 'destroy' do
    before do
      delete :destroy, params: { id: @expense.id }
    end

    it 'destroys an expense item' do
      expect(Expense.find_by(item: @apple_item)).to be_nil
    end

    it 'redirects to the expense index' do
      expect(response).to redirect_to expenses_path
    end

    it 'flashes a notice' do
      expect(flash[:notice]).to match(/Expense was successfully destroyed./)
    end
  end
end
