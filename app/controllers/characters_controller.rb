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
    if attempt_advance
      handle_advance_success
    else
      handle_advance_failure
    end
  end

  def launch_to_new_era
    character = @current_user
    TimeAdvancementHelper.increment_era(character)
    redirect_to root_path, notice: 'Moved to the next Era.'
  end

  private

  def attempt_advance
    Expense.advance_and_deduct?(@current_user)
  end

  def handle_advance_success
    TimeAdvancementHelper.increment_day(@current_user)
    redirect_to root_path, notice: 'Moved to the next day.'
  end

  def handle_advance_failure
    if @current_user.hour >= 10
      update_character_level_to_zero
      redirect_to game_over_path, alert: "Game Over: You can't afford to pay your expenses and have run out of time."
    else
      redirect_to root_path, notice: "You can't afford to pay your expenses yet!"
    end
  end

  def update_character_level_to_zero
    updated = @current_user.update(current_level: 0)
    Rails.logger.debug "Update operation successful: #{updated}"
  end

  def set_character
    @character = Character.find(params[:id])
  end
end
