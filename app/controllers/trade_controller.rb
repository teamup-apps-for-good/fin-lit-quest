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
    #puts "Offerer Inventory: #{npc_inventory.inspect}"
    #puts "Acceptor Inventory: #{player_inventory.inspect}"
    
    if trade_possible?(npc_inventory, player_inventory, npc, player)
      requiredItemNPC = npc.item_to_offer
      requiredQuantityNPC = npc.quantity_to_offer
  
      requiredItemPlayer = npc.item_to_accept
      requiredQuantityPlayer = npc.quantity_to_accept

      offerer_item = npc_inventory.find_by(item: requiredItemNPC)
      accepter_item = player_inventory.find_by(item: requiredItemPlayer)

      offerer_item.update(quantity: offerer_item.quantity - requiredQuantityNPC)
      accepter_item.update(quantity: accepter_item.quantity - requiredQuantityPlayer)

      npc_accepted_item = npc_inventory.find_by(item: requiredItemPlayer)
      player_accepted_item = player_inventory.find_by(item: requiredItemNPC)

      if npc_accepted_item
        npc_accepted_item.update(quantity: npc_accepted_item.quantity + requiredQuantityPlayer)
      else
        npc_accepted_item = Inventory.create(item: requiredItemPlayer, character: npc, quantity: requiredQuantityPlayer)
      end  

      if player_accepted_item
        player_accepted_item.update(quantity: player_accepted_item.quantity + requiredQuantityNPC)
      else
        player_accepted_item = Inventory.create(item: requiredItemNPC, character: player, quantity: requiredQuantityNPC)
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

  def trade_possible?(npc_inventory, player_inventory, npc, player)

    requiredItemNPC = npc.item_to_offer
    requiredQuantityNPC = npc.quantity_to_offer
    

    requiredItemPlayer = npc.item_to_accept
    requiredQuantityPlayer = npc.quantity_to_accept
    

    npc_item = npc_inventory.find_by(item: requiredItemNPC)
    npc_can_trade = npc_item.present? && npc_item.quantity >= requiredQuantityNPC
    
    player_item = player_inventory.find_by(item: requiredItemPlayer)
    player_can_trade = player_item.present? && player_item.quantity >= requiredQuantityPlayer

    
    return npc_can_trade && player_can_trade
  end
end
