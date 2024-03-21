# frozen_string_literal: true

# NonplayersController
class NonplayersController < SessionsController
  before_action :require_admin
  before_action :set_nonplayer, only: %i[show edit update destroy]

  # GET /nonplayers or /nonplayers.json
  def index
    @nonplayers = Nonplayer.all
  end

  # GET /nonplayers/1 or /nonplayers/1.json
  def show; end

  # GET /nonplayers/1/edit
  def edit; end

  # GET /nonplayers/new
  def new
    @nonplayer = Nonplayer.new
  end

  # POST /nonplayers or /nonplayers.json
  def create
    @nonplayer = Nonplayer.create(nonplayer_params)

    respond_to do |format|
      if @nonplayer.save
        format.html { redirect_to nonplayer_url(@nonplayer), notice: "#{@nonplayer.name} was successfully created." }
        format.json { render :show, status: :created, location: @nonplayer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @nonplayer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nonplayers/1 or /nonplayers/1.json
  def update
    respond_to do |format|
      @nonplayer.update(nonplayer_params)
      format.html { redirect_to nonplayer_url(@nonplayer), notice: "#{@nonplayer.name} was successfully updated." }
      format.json { render :show, status: :ok, location: @nonplayer }
    end
  end

  # DELETE /nonplayers/1 or /nonplayers/1.jsonc
  def destroy
    @nonplayer.destroy!

    respond_to do |format|
      format.html { redirect_to nonplayers_url, notice: "#{@nonplayer.name} was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_nonplayer
    @nonplayer = Nonplayer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def nonplayer_params
    # rubocop:disable Layout/LineLength
    new_params = params.require(:nonplayer).permit(:personality, :dialogue_content, :item_to_accept, :quantity_to_accept,
                                                   :item_to_offer, :quantity_to_offer, :name, :occupation, :inventory_slots, :balance, :current_level)
    # rubocop:enable Layout/LineLength
    begin
      new_params[:item_to_offer] = Item.find(new_params[:item_to_offer])
      new_params[:item_to_accept] = Item.find(new_params[:item_to_accept])
    rescue ActiveRecord::RecordNotFound
      return {}
    end
    new_params
  end
end
