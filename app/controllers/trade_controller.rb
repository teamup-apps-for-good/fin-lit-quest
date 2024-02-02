# frozen_string_literal: true

# TradeController
class TradeController < ApplicationController
  def trade
    @character = Nonplayer.find(params[:id])
    @item_to_offer = @character.item_to_offer.name
    @quantity_to_offer = @character.quantity_to_offer
    @item_to_accept = @character.item_to_accept.name
    @quantity_to_accept = @character.quantity_to_accept
    @player_has_item_to_trade = player_has_item_to_trade?
    @npc_has_offer_item = npc_has_offer_item?
  end

  def trade_accept
    player = Player.find(params[:character_id])
    npc = Nonplayer.find(params[:npc_id])

    npc_inventory = Inventory.where(character: params[:npc_id])
    player_inventory = Inventory.where(character: params[:character_id])
    # puts "Offerer Inventory: #{npc_inventory.inspect}"
    # puts "Acceptor Inventory: #{player_inventory.inspect}"

    if trade_possible?(npc_inventory, player_inventory, npc, player)
      required_item_npc = npc.item_to_offer
      required_quantity_npc = npc.quantity_to_offer

      required_item_player = npc.item_to_accept
      required_quantity_player = npc.quantity_to_accept

      offerer_item = npc_inventory.find_by(item: required_item_npc)
      accepter_item = player_inventory.find_by(item: required_item_player)

      offerer_item.update(quantity: offerer_item.quantity - required_quantity_npc)
      accepter_item.update(quantity: accepter_item.quantity - required_quantity_player)

      npc_accepted_item = npc_inventory.find_by(item: required_item_player)
      player_accepted_item = player_inventory.find_by(item: required_item_npc)

      if npc_accepted_item
        npc_accepted_item.update(quantity: npc_accepted_item.quantity + required_quantity_player)
      else
        Inventory.create(item: required_item_player, character: npc,
                         quantity: required_quantity_player)
      end

      if player_accepted_item
        player_accepted_item.update(quantity: player_accepted_item.quantity + required_quantity_npc)
      else
        Inventory.create(item: required_item_npc, character: player,
                         quantity: required_quantity_npc)
      end

      redirect_to character_profile_path, notice: 'Success!'
    else
      redirect_to character_profile_path, alert: 'Failed to trade, not enough items!'
    end
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

  private

  def trade_possible?(npc_inventory, player_inventory, npc, _player)
    required_item_npc = npc.item_to_offer
    required_quantity_npc = npc.quantity_to_offer

    required_item_player = npc.item_to_accept
    required_quantity_player = npc.quantity_to_accept

    npc_item = npc_inventory.find_by(item: required_item_npc)
    npc_can_trade = npc_item.present? && npc_item.quantity >= required_quantity_npc

    player_item = player_inventory.find_by(item: required_item_player)
    player_can_trade = player_item.present? && player_item.quantity >= required_quantity_player

    npc_can_trade && player_can_trade
  end
end
