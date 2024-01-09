# frozen_string_literal: true

json.extract! nonplayer, :id, :personality, :dialogue_content, :item_to_accept, :quantity_to_accept, :item_to_offer,
              :quantity_to_accept, :created_at, :updated_at
json.url nonplayer_url(nonplayer, format: :json)
