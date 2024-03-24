# frozen_string_literal: true

# Service class that handles the execution of counter offers, trades, buys, and sells.
class CounterOfferService
  def initialize(player_character, npc_character, offer_params)
    @player = player_character
    @npc = npc_character
    @offer_params = offer_params
    assign_trade_params
    trade_data = TradeData.new(@item_i_give_id, @quantity_i_give, @item_i_want_id, @quantity_i_want)
    trade_params = TradeParams.new(@player, @npc, trade_data)
    @validation_service = TradeValidationService.new(trade_params)
  end

  def execute_trade
    if trade_valid_and_items_available?
      perform_trade_transactions
      player_items_value = ValueCalculationService.value_of(@player, @item_i_give_id, @quantity_i_give)
      npc_items_value = ValueCalculationService.value_of(@npc, @item_i_want_id, @quantity_i_want)
      trade_good_deal = player_items_value <= npc_items_value
      [true, MessageService.generate_success_message(trade_good_deal)]
    else
      [false, MessageService.generate_error_message(@validation_service, @npc)]
    end
  end

  def execute_buy
    item = Item.find_by(id: @item_i_want_id)
    if @validation_service.npc_has_item? && @validation_service.player_can_afford?(total_price_of_items_wanted)
      perform_buy_transactions
      [true, "Successfully bought #{@quantity_i_want} #{item.name}!"]
    else
      [false, MessageService.generate_buy_error_message(@validation_service, total_price_of_items_wanted, @npc)]
    end
  end

  def execute_sell
    item = Item.find_by(id: @item_i_give_id)
    if @validation_service.user_has_item?
      perform_sell_transactions
      [true, "Successfully sold #{@quantity_i_give} #{item.name}!"]
    else
      [false, MessageService.generate_sell_error_message(@validation_service)]
    end
  end

  def assign_trade_params
    @item_i_give_id = @offer_params[:item_i_give_id]
    @quantity_i_give = @offer_params[:quantity_i_give].to_i
    @item_i_want_id = @offer_params[:item_i_want_id]
    @quantity_i_want = @offer_params[:quantity_i_want].to_i
  end

  def perform_trade_transactions
    ActiveRecord::Base.transaction do
      update_player_inventories
      update_npc_inventories
    end
  end

  def perform_buy_transactions
    ActiveRecord::Base.transaction do
      update_npc_inventory_for_buy
      update_player_inventory_and_balance_for_buy
    end
  end

  def perform_sell_transactions
    ActiveRecord::Base.transaction do
      update_player_inventory_and_balance_for_sell
      update_npc_inventory_for_sell
    end
  end

  def update_player_inventories
    InventoryService.update_inventory(@player, @item_i_give_id, -@quantity_i_give)
    InventoryService.update_inventory(@player, @item_i_want_id, @quantity_i_want)
  end

  def update_npc_inventories
    InventoryService.update_inventory(@npc, @item_i_want_id, -@quantity_i_want)
    InventoryService.update_inventory(@npc, @item_i_give_id, @quantity_i_give)
  end

  def update_player_inventory_and_balance_for_buy
    InventoryService.update_inventory(@player, @item_i_want_id, @quantity_i_want)
    new_balance = @player.balance - total_price_of_items_wanted
    @player.update!(balance: new_balance)
  end

  def update_npc_inventory_for_buy
    InventoryService.update_inventory(@npc, @item_i_want_id, -@quantity_i_want)
  end

  def update_player_inventory_and_balance_for_sell
    InventoryService.update_inventory(@player, @item_i_give_id, -@quantity_i_give)
    new_balance = @player.balance + total_sale_price_of_items_given
    @player.update!(balance: new_balance)
  end

  def update_npc_inventory_for_sell
    InventoryService.update_inventory(@npc, @item_i_give_id, @quantity_i_give)
  end
  
  def trade_is_valid?
    @validation_service.trade_valid?
  end

  def calculate_time_variance_for_trade(item, character)
    ValueCalculationService.calc_time_variance(item, character)
  end

  private

  def trade_valid_and_items_available?
    @validation_service.trade_valid? && @validation_service.npc_has_item? && @validation_service.user_has_item?
  end

  def total_price_of_items_wanted
    ValueCalculationService.value_of(@npc, @item_i_want_id, @quantity_i_want)
  end

  def total_sale_price_of_items_given
    ValueCalculationService.value_of(@player, @item_i_give_id, @quantity_i_give)
  end
end
