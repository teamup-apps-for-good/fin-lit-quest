# frozen_string_literal: true

json.extract! expense, :id, :frequency, :number, :item_id, :quantity, :created_at, :updated_at
json.url expense_url(expense, format: :json)
