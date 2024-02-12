# frozen_string_literal: true

json.array! @preferences, partial: 'preferences/preference', as: :preference
