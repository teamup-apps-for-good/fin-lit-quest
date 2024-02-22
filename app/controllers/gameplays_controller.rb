# frozen_string_literal: true

# GameplaysController
class GameplaysController < SessionsController
  before_action :check_game_over, except: [:game_over, :restart]

  def town
    @nonplayers = Nonplayer.where(current_level: @current_user.current_level)
  end

  def game_over; end

  def check_game_over
    redirect_to game_over_path, alert: "Game Over: You can't continue the game." if @current_user.current_level == 0
  end

  def restart
    @current_user.update(current_level: 1, balance:0, day: 1, hour: 1)
    redirect_to root_path, notice: 'Game restarted successfully.'
  end
  

end
