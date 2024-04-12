# frozen_string_literal: true

# Service class for handling the creation of buy offers
class BuyCreateService
  def initialize(current_user, context, params)
    @current_user = current_user
    @context = context
    @params = params
  end

  def execute
    if too_late?
      [false, 'It is too late! Move to the next day']
    elsif !validate_buy_params
      [false, 'Please fill in all required fields for buy']
    else
      execute_buy
    end
  end

  private

  def too_late?
    @current_user.hour == 10
  end

  def validate_buy_params
    @params[:item_i_want_id].present? && @params[:quantity_i_want].present?
  end

  def execute_buy
    counter_offer_service = CounterOfferService.new(@context.player_character, @context.character, @params)
    success, message = counter_offer_service.execute_buy

    TimeAdvancementHelper.increment_hour(@current_user) if success

    [success, message]
  end
end
