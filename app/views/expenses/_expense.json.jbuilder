json.extract! expense, :id, :type, :number, :item_id, :quantity, :created_at, :updated_at
json.url expense_url(expense, format: :json)
