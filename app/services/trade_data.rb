# frozen_string_literal: true

# Class that encapsulates the trade-specific data parameters.
class TradeData
  attr_reader :item_i_give_id, :quantity_i_give, :item_i_want_id, :quantity_i_want

  def initialize(item_i_give_id, quantity_i_give, item_i_want_id, quantity_i_want)
    @item_i_give_id = item_i_give_id
    @quantity_i_give = quantity_i_give
    @item_i_want_id = item_i_want_id
    @quantity_i_want = quantity_i_want
  end
end
