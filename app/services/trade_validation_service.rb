# frozen_string_literal: true

# Service class that validates the trade parameters and checks item availability.
class TradeValidationService
  def initialize(trade_params)
    @player = trade_params.player_character
    @npc = trade_params.npc_character
    @trade_data = trade_params.trade_data
  end

  def trade_valid?
    value_of(@npc, @trade_data.item_i_give_id,
             @trade_data.quantity_i_give) >= value_of(@npc, @trade_data.item_i_want_id, @trade_data.quantity_i_want)
  end

  def npc_has_item?
    @npc.inventories.find_by(item_id: @trade_data.item_i_want_id)
  end

  def user_has_item?
    inventory_item = @player.inventories.find_by(item_id: @trade_data.item_i_give_id)
    inventory_item && inventory_item.quantity >= @trade_data.quantity_i_give
  end

  def player_item_quantity
    inventory_item = @player.inventories.find_by(item_id: @trade_data.item_i_give_id)
    inventory_item ? inventory_item.quantity : 0
  end

  def npc_item_quantity
    inventory_item = @npc.inventories.find_by(item_id: @trade_data.item_i_want_id)
    inventory_item ? inventory_item.quantity : 0
  end

  def player_can_afford?(total_price)
    @player.balance >= total_price
  end

  private

  def value_of(character, item_id, quantity)
    ValueCalculationService.value_of(character, item_id, quantity)
  end
end
