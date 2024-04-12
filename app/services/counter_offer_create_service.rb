# frozen_string_literal: true

# Service class for handling the creation of counter offers
class CounterOfferCreateService
  def initialize(current_user, context, params)
    @current_user = current_user
    @context = context
    @params = params
  end

  def execute
    if too_late?
      [false, 'It is too late! Move to the next day']
    elsif !validate_counter_offer_params
      [false, 'Please fill in all required fields']
    else
      execute_counter_offer
    end
  end

  private

  def too_late?
    @current_user.hour == 10
  end

  def validate_counter_offer_params
    @params[:item_i_give_id].present? && @params[:quantity_i_give].present? &&
      @params[:item_i_want_id].present? && @params[:quantity_i_want].present?
  end

  def execute_counter_offer
    service = CounterOfferService.new(@context.player_character, @context.character, @params)
    success, message = service.execute_trade

    TimeAdvancementHelper.increment_hour(@current_user)

    if success
      TimeAdvancementHelper.increment_hour(@current_user)
      [true, message]
    else
      [false, message]
    end
  end
end
