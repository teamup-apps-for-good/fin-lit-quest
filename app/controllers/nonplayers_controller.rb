# frozen_string_literal: true

# NonplayersController
class NonplayersController < ApplicationController
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
    begin
      new_params = nonplayer_params
      new_params[:item_to_offer] = Item.find(Integer(nonplayer_params['item_to_offer']))
      new_params[:item_to_accept] = Item.find(Integer(nonplayer_params['item_to_accept']))
      @nonplayer = Nonplayer.create(new_params)
    rescue StandardError
      redirect_to new_nonplayer_path
      return
    end

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
      new_params = nonplayer_params
      new_params[:item_to_offer] = Item.find(Integer(nonplayer_params['item_to_offer']))
      new_params[:item_to_accept] = Item.find(Integer(nonplayer_params['item_to_accept']))
      if @nonplayer.update(new_params)
        format.html { redirect_to nonplayer_url(@nonplayer), notice: "#{@nonplayer.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @nonplayer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @nonplayer.errors, status: :unprocessable_entity }
      end
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
    params.require(:nonplayer).permit(:personality, :dialogue_content, :item_to_accept, :quantity_to_accept,
                                      :item_to_offer, :quantity_to_offer, :name, :occupation, :inventory_slots, :balance, :current_level)
    # rubocop:enable Layout/LineLength
  end
end
