# frozen_string_literal: true

# CharactersController
class CharactersController < ApplicationController
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
    character = Player.first
    TimeAdvancementHelper.increment_day(character)
    redirect_to root_path, notice: 'Moved to the next day.'
  end

  def launch_to_new_era
    character = Player.first
    TimeAdvancementHelper.increment_era(character)
    redirect_to root_path, notice: 'Moved to the next Era.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_character
    @character = Character.find(params[:id])
  end
end
