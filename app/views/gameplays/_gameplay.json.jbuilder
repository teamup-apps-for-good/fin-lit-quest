# frozen_string_literal: true

json.extract! gameplay, :id, :created_at, :updated_at
json.url gameplay_url(gameplay, format: :json)
