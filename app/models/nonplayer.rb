# frozen_string_literal: true

class Nonplayer < Character
  belongs_to :item_to_accept, class_name: 'Item', foreign_key: 'item_to_accept_id'
  belongs_to :item_to_offer, class_name: 'Item', foreign_key: 'item_to_offer_id'
end
