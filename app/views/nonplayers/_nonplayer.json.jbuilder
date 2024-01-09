# frozen_string_literal: true

json.extract! nonplayer, :id, :character_id, :personality, :dialogue_id, :created_at, :updated_at
json.url nonplayer_url(nonplayer, format: :json)
