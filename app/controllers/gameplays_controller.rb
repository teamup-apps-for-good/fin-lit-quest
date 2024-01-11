# frozen_string_literal: true

# GameplaysController
class GameplaysController < ApplicationController
  def town
    @characters = Character.all
  end
end
