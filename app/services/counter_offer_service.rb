# frozen_string_literal: true

# Service class to handle the logic for counter-offers in the game.
# This includes validating the trade and updating inventories.
class CounterOfferService
  def initialize(player_character, npc_character, offer_params)
    @player_character = player_character
    @npc_character = npc_character
    @offer_params = offer_params
    assign_trade_params
  end

  def execute_trade
    if trade_valid_and_items_available?
      perform_trade_transactions
      [true, '']
    else
      [false, generate_error_message]
    end
  end

  def assign_trade_params
    @item_i_give_id = @offer_params[:item_i_give_id]
    @quantity_i_give = @offer_params[:quantity_i_give].to_i
    @item_i_want_id = @offer_params[:item_i_want_id]
    @quantity_i_want = @offer_params[:quantity_i_want].to_i
  end

  def trade_valid_and_items_available?
    valid_trade? && npc_has_item?
  end

  def perform_trade_transactions
    ActiveRecord::Base.transaction do
      update_player_inventories
      update_npc_inventories
    end
  end

  def update_player_inventories
    InventoryService.update_inventory(@player_character, @item_i_give_id, -@quantity_i_give)
    InventoryService.update_inventory(@player_character, @item_i_want_id, @quantity_i_want)
  end

  def update_npc_inventories
    InventoryService.update_inventory(@npc_character, @item_i_want_id, -@quantity_i_want)
    InventoryService.update_inventory(@npc_character, @item_i_give_id, @quantity_i_give)
  end

  def generate_error_message
    if valid_trade?
      "#{@npc_character.name} does not have the item you are trying to get"
    else
      "#{@npc_character.name} did not accept your offer!"
    end
  end

  def valid_trade?
    value_of_given_items >= value_of_wanted_items
  end

  def npc_has_item?
    inventory_item = @npc_character.inventories.find_by(item_id: @item_i_want_id)
    inventory_item && inventory_item.quantity >= @quantity_i_want
  end

  def calculate_total_value(item_id, quantity)
    item = Item.find_by(id: item_id)
    item&.value.to_i * quantity
  end

  def value_of_given_items
    calculate_total_value(@item_i_give_id, @quantity_i_give)
  end

  def value_of_wanted_items
    calculate_total_value(@item_i_want_id, @quantity_i_want)
  end
end
