# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShoppingListsController, type: :controller do
    before do
        ShoppingList.destroy_all
    end