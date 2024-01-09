# frozen_string_literal: true

json.array! @items, partial: 'items/item', as: :item
