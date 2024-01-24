# frozen_string_literal: true

json.array! @shopping_lists, partial: 'shopping_lists/shopping_list', as: :shopping_list
