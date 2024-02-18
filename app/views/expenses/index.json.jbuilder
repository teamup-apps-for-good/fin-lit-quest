# frozen_string_literal: true

json.array! @expenses, partial: 'expenses/expense', as: :expense
