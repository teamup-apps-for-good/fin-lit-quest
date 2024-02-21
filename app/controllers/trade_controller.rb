# frozen_string_literal: true

# TradeController
class TradeController < SessionsController
  def trade
    @character = Nonplayer.find(params[:id])
    @item_to_offer = @character.item_to_offer.name
    @quantity_to_offer = @character.quantity_to_offer
    @item_to_accept = @character.item_to_accept.name
    @quantity_to_accept = @character.quantity_to_accept
    @player_has_item_to_trade = player_has_item_to_trade?
    @npc_has_offer_item = npc_has_offer_item?
    @pref = Preference.find_by(occupation: @character.occupation)
  end

  def trade_accept
    player = Player.find(params[:character_id])
    npc = Nonplayer.find(params[:npc_id])

    npc_inventory = Inventory.where(character: npc)
    player_inventory = Inventory.where(character: player)

    if trade_possible?(npc_inventory, player_inventory, npc)
      make_trade(npc_inventory, player_inventory, npc, player)
      redirect_to character_profile_path, notice: 'Success!'
    else
      redirect_to character_profile_path, alert: 'Failed to trade, not enough items!'
    end
  end

  private

  def make_trade(npc_inventory, player_inventory, npc, player)
    required_item_npc = npc.item_to_offer
    required_quantity_npc = npc.quantity_to_offer

    required_item_player = npc.item_to_accept
    required_quantity_player = npc.quantity_to_accept

    update_inventory_quantity(npc_inventory, required_item_npc, -required_quantity_npc)
    update_inventory_quantity(player_inventory, required_item_player, -required_quantity_player)

    update_or_create_inventory(npc_inventory, required_item_player, npc, required_quantity_player)
    update_or_create_inventory(player_inventory, required_item_npc, player, required_quantity_npc)
  end

  def update_inventory_quantity(inventory, item, quantity_change)
    inventory_item = inventory.find_by(item:)
    inventory_item&.update(quantity: inventory_item.quantity + quantity_change)
  end

  def update_or_create_inventory(inventory, item, character, quantity)
    inventory_item = inventory.find_by(item:)
    if inventory_item
      inventory_item.update(quantity: inventory_item.quantity + quantity)
    else
      Inventory.create(item:, character:, quantity:)
    end
  end

  def trade_possible?(npc_inventory, player_inventory, npc)
    required_item_npc = npc.item_to_offer
    required_quantity_npc = npc.quantity_to_offer

    required_item_player = npc.item_to_accept
    required_quantity_player = npc.quantity_to_accept

    npc_can_trade = sufficient_items?(npc_inventory, required_item_npc, required_quantity_npc)
    player_can_trade = sufficient_items?(player_inventory, required_item_player, required_quantity_player)

    npc_can_trade && player_can_trade
  end

  def sufficient_items?(inventory, item, quantity)
    inventory_item = inventory.find_by(item:)
    inventory_item.present? && inventory_item.quantity >= quantity
  end

  def player_has_item_to_trade?
    player = Player.first
    player_inventory = Inventory.find_by(item: @character.item_to_accept, character: player)
    player_inventory.present?
  end

  def npc_has_offer_item?
    npc_inventory = Inventory.find_by(item: @character.item_to_offer, character: @character)
    npc_inventory.present?
  end
end
