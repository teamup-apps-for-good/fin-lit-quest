# frozen_string_literal: true

# Controller for handling counter offers in the game.
class CounterOfferController < ApplicationController
  before_action :set_context
  attr_reader :context

  def show; end

  def create
    if validate_counter_offer_params
      execute_counter_offer
    else
      flash[:alert] = 'Please fill in all required fields'
      redirect_to request.referer || root_path
    end
  end

  private

  def set_context
    name_param = params[:name]
    @context = CharacterInventoryService.build_context(name_param)
  end

  def validate_counter_offer_params
    params[:item_i_give_id].present? && params[:quantity_i_give].present? &&
      params[:item_i_want_id].present? && params[:quantity_i_want].present?
  end

  def execute_counter_offer
    service = CounterOfferService.new(@context.player_character, @context.character, counter_offer_params)
    success, message = service.execute_trade
    if success
      flash[:notice] = 'Success!'
    else
      flash[:alert] = message
    end
    redirect_to counter_offer_path(name: @context.name)
  end

  def counter_offer_params
    params.permit(:item_i_give_id, :quantity_i_give, :item_i_want_id, :quantity_i_want)
  end
end
