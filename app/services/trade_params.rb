# frozen_string_literal: true

# Class that encapsulates the parameters required for a trade.
class TradeParams
  attr_reader :player_character, :npc_character, :trade_data

  def initialize(player_character, npc_character, trade_data)
    @player_character = player_character
    @npc_character = npc_character
    @trade_data = trade_data
  end
end
