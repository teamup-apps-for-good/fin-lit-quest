# frozen_string_literal: true

# Service class to handle the logic for counter-offers in the game.
# This includes validating the trade and updating inventories.
class CounterOfferService
  def initialize(player_character, npc_character, offer_params)
    @player = player_character
    @npc = npc_character
    @offer_params = offer_params
    @trade_good_deal = true
    assign_trade_params
  end

  def execute_trade
    if trade_valid_and_items_available?
      perform_trade_transactions
      [true, generate_success_message]
    else
      [false, generate_error_message]
    end
  end

  def execute_buy
    item = Item.find_by(id: @item_i_want_id)
    if npc_has_item? && player_can_afford?
      perform_buy_transactions
      [true, "Successfully bought #{@quantity_i_want} #{item.name}!"]
    else
      [false, generate_buy_error_message]
    end
  end

  def assign_trade_params
    @item_i_give_id = @offer_params[:item_i_give_id]
    @quantity_i_give = @offer_params[:quantity_i_give].to_i
    @item_i_want_id = @offer_params[:item_i_want_id]
    @quantity_i_want = @offer_params[:quantity_i_want].to_i
  end

  def trade_valid_and_items_available?
    valid_trade? && npc_has_item? && user_has_item?
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

  def generate_error_message
    return "You don't have the item you are trying to give." if player_item_quantity.zero?
    return "You do not have enough items to trade!" unless user_has_item?
  
    return "#{@npc.name} does not have the item you are trying to get." if npc_item_quantity.zero?
    return "#{@npc.name} does not have enough items for the trade!" unless npc_has_item?
  
    return "#{@npc.name} did not accept your offer!" unless valid_trade?
  
  end

  def generate_success_message
    if @trade_good_deal
      'Success!'
    else
      "Success, but that wasn't the best deal."
    end
  end

  def valid_trade?
    if value_of(@npc, @item_i_give_id, @quantity_i_give) > value_of(@npc, @item_i_want_id, @quantity_i_want)
      @trade_good_deal = false
    end
    value_of(@npc, @item_i_give_id, @quantity_i_give) >= value_of(@npc, @item_i_want_id, @quantity_i_want)
  end

  def npc_has_item?
    inventory_item = @npc.inventories.find_by(item_id: @item_i_want_id)
    inventory_item && inventory_item.quantity >= @quantity_i_want
  end

  def user_has_item?
    inventory_item = @player.inventories.find_by(item_id: @item_i_give_id)
    inventory_item && inventory_item.quantity >= @quantity_i_give
  end

  def player_item_quantity
    inventory_item = @player.inventories.find_by(item_id: @item_i_give_id)
    inventory_item ? inventory_item.quantity : 0
  end
  
  def npc_item_quantity
    inventory_item = @npc.inventories.find_by(item_id: @item_i_want_id)
    inventory_item ? inventory_item.quantity : 0
  end

  def calculate_total_value(item_id, quantity)
    item = Item.find_by(id: item_id)
    item&.value.to_i * quantity
  end

  def total_price_of_items_wanted
    value_of(@npc, @item_i_want_id, @quantity_i_want)
  end

  def player_can_afford?
    @player.balance >= total_price_of_items_wanted
  end
  
  def generate_buy_error_message
    return "You do not have enough money to purchase these item(s)" unless player_can_afford?
    "#{@npc.name} does not have enough items for the sale!" unless npc_has_item?
  end

  def value_of(npc, item_id, quantity)
    item = Item.find_by(id: item_id)
    pref = Preference.find_by(occupation: npc.occupation)
    total_value = calculate_total_value(item_id, quantity)

    time_variance = calc_time_variance(item, @player)

    adjusted_value = if pref && (pref.item.id == item_id.to_i)
                       total_value * pref.multiplier * time_variance
                     else
                       total_value * time_variance
                     end
    adjusted_value.ceil
  end

  def calc_time_variance(item, player)
    return 1.0 if player.day == 1

    seed = (player.day << 100) + item.id
    rng = Random.new(seed)
    min = 0.5
    max = 1.5
    rng.rand(min..max)
  end
end
