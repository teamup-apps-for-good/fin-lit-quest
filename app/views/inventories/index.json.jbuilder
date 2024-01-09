# frozen_string_literal: true

json.array! @inventories, partial: 'inventories/inventory', as: :inventory
