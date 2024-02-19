# frozen_string_literal: true

# GameplaysController
class GameplaysController < ApplicationController
  def town
    @nonplayers = Nonplayer.where(current_level: @current_user.current_level)
  end
end
