# frozen_string_literal: true

# Controller for handling counter offers in the game.
class CounterOfferController < SessionsController
  before_action :set_context
  attr_reader :context

  def show; end

  def create
    character = @current_user
    if character.hour == 10
      redirect_to root_path, notice: 'It is too late! Move to the next day'
    elsif validate_counter_offer_params
      execute_counter_offer
    else
      flash[:alert] = 'Please fill in all required fields'
      redirect_to request.referer || root_path
    end
  end

  private

  def set_context
    id_param = params[:id]
    @context = CharacterInventoryService.build_context_by_id(id_param, @current_user)
    @pref = Preference.find_by(occupation: @context.character.occupation)
  end

  def validate_counter_offer_params
    params[:item_i_give_id].present? && params[:quantity_i_give].present? &&
      params[:item_i_want_id].present? && params[:quantity_i_want].present?
  end

  def execute_counter_offer
    service = CounterOfferService.new(@context.player_character, @context.character, counter_offer_params)
    success, message = service.execute_trade

    TimeAdvancementHelper.increment_hour(@current_user)

    if success
      TimeAdvancementHelper.increment_hour(@current_user)
      flash[:notice] = message
    else
      flash[:alert] = message
    end
    redirect_to trade_path(id: @context.character.id)
  end

  def counter_offer_params
    params.permit(:item_i_give_id, :quantity_i_give, :item_i_want_id, :quantity_i_want)
  end
end
