# frozen_string_literal: true

# CharactersController
class CharactersController < ApplicationController
  before_action :set_character, only: %i[show]

  # GET /characters or /characters.json
  def index
    @characters = Character.all
  end

  # GET /characters/1 or /characters/1.json
  def show; end

  def profile
    @character = Character.find(params[:id])
  end

  def inventory
    @character = Character.find(params[:id])
    @items = @character.items
    @inventories = @character.inventories
    @level = @character.current_level
  end

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

    if trade_possible?(npc_inventory, player_inventory, npc, player)
      trade_items(npc_inventory, player_inventory, npc, player)
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

  def trade_items(npc_inventory, player_inventory, npc, player)
    trade_required_items(npc_inventory, player_inventory, npc, player)
    trade_accepted_items(npc_inventory, player_inventory, npc, player)
  end

  def trade_required_items(npc_inventory, player_inventory, npc, _player)
    update_item_quantity(npc_inventory, npc.item_to_offer, -npc.quantity_to_offer)
    update_item_quantity(player_inventory, npc.item_to_accept, -npc.quantity_to_accept)
  end

  def trade_accepted_items(npc_inventory, player_inventory, npc, player)
    update_or_create_item(npc_inventory, npc.item_to_accept, player, npc.quantity_to_accept)
    update_or_create_item(player_inventory, npc.item_to_offer, npc, npc.quantity_to_offer)
  end

  def update_item_quantity(inventory, item, quantity_change)
    inventory_item = inventory.find_by(item:)
    inventory_item.update(quantity: inventory_item.quantity + quantity_change)
  end

  def update_or_create_item(inventory, item, character, quantity)
    inventory_item = inventory.find_by(item:)
    if inventory_item
      inventory_item.update(quantity: inventory_item.quantity + quantity)
    else
      Inventory.create(item:, character:, quantity:)
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_character
    @character = Character.find(params[:id])
  end
end
