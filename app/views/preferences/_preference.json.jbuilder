# frozen_string_literal: true

json.extract! preference, :id, :occupation, :item_id, :multiplier, :created_at, :updated_at
json.url preference_url(preference, format: :json)
