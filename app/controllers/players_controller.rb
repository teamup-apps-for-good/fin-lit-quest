# frozen_string_literal: true

# PlayersController
class PlayersController < SessionsController
  before_action :require_admin
  before_action :set_player, only: %i[show edit update destroy]

  # GET /players or /players.json
  def index
    @players = Player.all
  end

  # GET /players/1 or /players/1.json
  def show; end

  # GET /players/1/edit
  def edit; end

  # POST /players or /players.json
  def create
    make_player

    respond_to do |format|
      @player.save
      format.html { redirect_to player_url(@player), notice: 'Your profile was successfully created. Welcome!' }
      format.json { render :show, status: :created, location: @player }
    end
  end

  # PATCH/PUT /players/1 or /players/1.json
  def update
    respond_to do |format|
      @player.update(player_params)
      format.html { redirect_to player_url(@player), notice: 'Your profile has been updated.' }
      format.json { render :show, status: :ok, location: @player }
    end
  end

  # DELETE /players/1 or /players/1.json
  def destroy
    @player.destroy!

    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Your profile has been deleted.' }
      format.json { head :no_content }
    end
  end

  def new
    @player = Player.new
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_player
    @player = Player.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def player_params
    params.require(:player).permit(:current_level, :name, :occupation, :inventory_slots, :balance, :email, :provider,
                                   :uid)
  end

  def make_player
    @player = Player.new(player_params)

    @player.add_starter_items
  end
end
