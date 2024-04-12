# frozen_string_literal: true

# spec/controllers/concerns/counter_offer_validations_spec.rb
require 'rails_helper'

# Define a dummy controller to include the concern
class DummyController < ApplicationController
  include CounterOfferValidations

  public :validate_counter_offer_params, :validate_buy_params, :validate_sell_params
end

RSpec.describe DummyController, type: :controller do
  describe 'CounterOfferValidations' do
    describe '#validate_counter_offer_params' do
      it 'returns true when all parameters are present' do
        controller.params = ActionController::Parameters.new(
          item_i_give_id: '1',
          quantity_i_give: '2',
          item_i_want_id: '3',
          quantity_i_want: '4'
        )
        expect(controller.validate_counter_offer_params).to be true
      end

      it 'returns false when any parameter is missing' do
        controller.params = ActionController::Parameters.new(
          item_i_give_id: '',
          quantity_i_give: '2',
          item_i_want_id: '3',
          quantity_i_want: '4'
        )
        expect(controller.validate_counter_offer_params).to be false
      end
    end

    describe '#validate_buy_params' do
      it 'returns true when both parameters are present' do
        controller.params = ActionController::Parameters.new(
          item_i_want_id: '3',
          quantity_i_want: '4'
        )
        expect(controller.validate_buy_params).to be true
      end

      it 'returns false when any parameter is missing' do
        controller.params = ActionController::Parameters.new(
          item_i_want_id: '',
          quantity_i_want: '4'
        )
        expect(controller.validate_buy_params).to be false
      end
    end

    describe '#validate_sell_params' do
      it 'returns true when both parameters are present' do
        controller.params = ActionController::Parameters.new(
          item_i_give_id: '1',
          quantity_i_give: '2'
        )
        expect(controller.validate_sell_params).to be true
      end

      it 'returns false when any parameter is missing' do
        controller.params = ActionController::Parameters.new(
          item_i_give_id: '1',
          quantity_i_give: ''
        )
        expect(controller.validate_sell_params).to be false
      end
    end
  end
end
