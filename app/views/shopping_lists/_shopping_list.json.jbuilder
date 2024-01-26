# frozen_string_literal: true

json.extract! shopping_list, :id, :item_id, :level, :quantity, :created_at, :updated_at
json.url shopping_list_url(shopping_list, format: :json)
