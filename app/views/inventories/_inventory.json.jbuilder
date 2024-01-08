json.extract! inventory, :id, :item, :owner_id, :quantity, :created_at, :updated_at
json.url inventory_url(inventory, format: :json)
