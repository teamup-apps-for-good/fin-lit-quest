# frozen_string_literal: true

# Nonplayer Model
class Nonplayer < Character
  belongs_to :item_to_accept, class_name: 'Item', foreign_key: 'item_to_accept_id'
  belongs_to :item_to_offer, class_name: 'Item', foreign_key: 'item_to_offer_id'
  validates :name, :occupation, :inventory_slots, :balance, :current_level, :personality, :dialogue_content,
            :quantity_to_accept, :quantity_to_offer, :item_to_accept, :item_to_offer, presence: true
end
