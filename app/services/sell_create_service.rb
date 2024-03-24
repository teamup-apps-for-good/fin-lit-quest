# frozen_string_literal: true

# Service class for handling the creation of sell offers
class SellCreateService
  def initialize(current_user, context, params)
    @current_user = current_user
    @context = context
    @params = params
  end

  def execute
    if too_late?
      [false, 'It is too late! Move to the next day']
    elsif !validate_sell_params
      [false, 'Please fill in all required fields for sell']
    else
      execute_sell
    end
  end

  private

  def too_late?
    @current_user.hour == 10
  end

  def validate_sell_params
    @params[:item_i_give_id].present? && @params[:quantity_i_give].present?
  end

  def execute_sell
    counter_offer_service = CounterOfferService.new(@context.player_character, @context.character, @params)
    success, message = counter_offer_service.execute_sell

    TimeAdvancementHelper.increment_hour(@current_user) if success

    [success, message]
  end
end
