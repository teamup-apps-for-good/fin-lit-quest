# frozen_string_literal: true

# CharactersController
class CharactersController < SessionsController
  before_action :set_character, only: %i[show]

  # GET /characters or /characters.json
  def index
    @characters = Character.all
  end

  # GET /characters/1 or /characters/1.json
  def show; end

  def profile
    @character = Character.find(params[:id])
  end

  def inventory
    @character = Character.find(params[:id])
    @items = @character.items
    @inventories = @character.inventories
    @level = @character.current_level
  end

  def advance_day
    character = @current_user
    current_hour = character.hour
    advance = Expense.advance_and_deduct?(character)
    if advance
      TimeAdvancementHelper.increment_day(character)
      redirect_to root_path, notice: 'Moved to the next day.'
    else
      if current_hour >= 10
        updated = character.update(current_level: 0)
        Rails.logger.debug "Update operation successful: #{updated}"
        redirect_to game_over_path, alert: "Game Over: You can't afford to pay your expenses and have run out of time."
      else
        redirect_to root_path, notice: "You can't afford to pay your expenses yet!"
      end
    end
  end

  def launch_to_new_era
    character = @current_user
    TimeAdvancementHelper.increment_era(character)
    redirect_to root_path, notice: 'Moved to the next Era.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_character
    @character = Character.find(params[:id])
  end
end
