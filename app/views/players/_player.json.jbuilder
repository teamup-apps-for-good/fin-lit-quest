# frozen_string_literal: true

json.extract! player, :id, :current_level, :created_at, :updated_at
json.url player_url(player, format: :json)
