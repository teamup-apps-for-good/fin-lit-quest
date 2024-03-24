# frozen_string_literal: true

# Service class that generates success and error messages for counter offers.
class MessageService
  def self.generate_success_message(trade_good_deal)
    if trade_good_deal
      'Success!'
    else
      "Success, but that wasn't the best deal."
    end
  end

  def self.generate_error_message(validation_service, npc)
    return "You don't have the item you are trying to give." if validation_service.player_item_quantity.zero?
    return 'You do not have enough items to trade!' unless validation_service.user_has_item?

    return "#{npc.name} does not have the item you are trying to get." if validation_service.npc_item_quantity.zero?
    return "#{npc.name} does not have enough items for the trade!" unless validation_service.npc_has_item?

    "#{npc.name} did not accept your offer!" unless validation_service.trade_valid?
  end

  def self.generate_buy_error_message(validation_service, total_price, npc)
    unless validation_service.player_can_afford?(total_price)
      return 'You do not have enough money to purchase these item(s)'
    end

    "#{npc.name} does not have enough items for the sale!" unless validation_service.npc_has_item?
  end

  def self.generate_sell_error_message(validation_service)
    'You do not have enough items to sell!' unless validation_service.user_has_item?
  end
end
