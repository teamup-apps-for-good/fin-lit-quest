# frozen_string_literal: true

# GameplaysController
class GameplaysController < ApplicationController
  def town
    @player_level = Player.first.current_level
    @characters = Character.where(current_level: @player_level)
  end
end
