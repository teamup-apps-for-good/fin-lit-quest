# frozen_string_literal: true

# Handles counter offer actions and interactions
class CounterOfferController < SessionsController
  include CounterOfferValidations
  before_action :set_context
  before_action :set_counter_offer_service, only: %i[show create barter buy sell buy_create sell_create]
  attr_reader :context, :counter_offer_service

  def show
    set_inventories
  end

  def create
    return redirect_to root_path, notice: 'It is too late! Move to the next day' if time_too_late?
    return handle_invalid_params unless valid_counter_offer_params?

    service = CounterOfferCreateService.new(@current_user, @context, counter_offer_params)
    success, message = service.execute
    handle_counter_offer_result(success, message)
  end

  def barter
    set_inventories
    render 'barter'
  end

  def buy
    set_inventories
    render 'buy'
  end

  def buy_create
    service = BuyCreateService.new(@current_user, @context, buy_params)
    success, message = service.execute
    handle_buy_result(success, message)
  end

  def sell
    set_inventories
    render 'sell'
  end

  def sell_create
    service = SellCreateService.new(@current_user, @context, sell_params)
    success, message = service.execute
    handle_sell_result(success, message)
  end

  def calculate_price
    item_id = params[:item_id]
    quantity = params[:quantity].to_i
    transaction_type = params[:transaction_type]
    Item.find(item_id)
    price = calculate_unit_price(transaction_type, item_id)
    total_price = price * quantity
    render json: { total_price: }
  end

  private

  def calculate_unit_price(transaction_type, item_id)
    if transaction_type == 'buy'
      ValueCalculationService.value_of(@context.character, item_id, 1)
    else
      ValueCalculationService.value_of(@current_user, item_id, 1)
    end
  end

  def time_too_late?
    @context.character.hour == 10
  end

  def valid_counter_offer_params?
    validate_counter_offer_params
  end

  def handle_invalid_params
    flash[:alert] = 'Please fill in all required fields'
    redirect_to request.referer || root_path
  end

  def handle_counter_offer_result(success, message)
    flash[success ? :notice : :alert] = message
    redirect_to trade_path(id: @context.character.id)
  end

  def set_context
    id_param = params[:id]
    @context = CharacterInventoryService.build_context_by_id(id_param, @current_user)
    @pref = Preference.find_by(occupation: @context.character.occupation)
  end

  def set_inventories
    @inventory_hash_player = InventoryService.inventory_for(@current_user)
    @inventory_hash_npc = InventoryService.inventory_for(@context.character)
  end

  def handle_buy_result(success, message)
    if success
      redirect_to trade_path(id: @context.character.id), notice: message
    else
      flash[:alert] = message
      redirect_to request.referer || root_path
    end
  end

  def handle_sell_result(success, message)
    if success
      redirect_to trade_path(id: @context.character.id), notice: message
    else
      flash[:alert] = message
      redirect_to request.referer || root_path
    end
  end

  def counter_offer_params
    params.permit(:item_i_give_id, :quantity_i_give, :item_i_want_id, :quantity_i_want)
  end

  def buy_params
    params.permit(:item_i_want_id, :quantity_i_want)
  end

  def sell_params
    params.permit(:item_i_give_id, :quantity_i_give)
  end

  def set_counter_offer_service
    @counter_offer_service = CounterOfferService.new(@context.player_character, @context.character,
                                                     counter_offer_params)
  end
end
