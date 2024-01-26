# frozen_string_literal: true

# ShoppingListsController
class ShoppingListsController < ApplicationController
  before_action :set_shopping_list, only: %i[show edit update destroy]

  # GET /shopping_lists or /shopping_lists.json
  def index
    @shopping_lists = ShoppingList.all
  end

  def player_shopping_list
    @player_level = Player.first.current_level
    @level_shopping_lists = ShoppingList.where(level: @player_level)
  end

  # GET /shopping_lists/1 or /shopping_lists/1.json
  def show; end

  # GET /shopping_lists/new
  def new
    @shopping_list = ShoppingList.new
  end

  # GET /shopping_lists/1/edit
  def edit; end

  # POST /shopping_lists or /shopping_lists.json
  def create
    new_params = {
      item: Item.find_by(name: shopping_list_params['item']),
      level: shopping_list_params['level'],
      quantity: shopping_list_params['quantity']
    }
    @shopping_list = ShoppingList.new(new_params)

    respond_to do |format|
      if @shopping_list.save
        format.html { redirect_to shopping_list_url(@shopping_list), notice: 'Shopping list was successfully created.' }
        format.json { render :show, status: :created, location: @shopping_list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shopping_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shopping_lists/1 or /shopping_lists/1.json
  def update
    new_params = {
      item: Item.find_by(name: shopping_list_params['item']),
      level: shopping_list_params['level'],
      quantity: shopping_list_params['quantity']
    }

    respond_to do |format|
      if @shopping_list.update(new_params)
        format.html { redirect_to shopping_list_url(@shopping_list), notice: 'Shopping list was successfully updated.' }
        format.json { render :show, status: :ok, location: @shopping_list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shopping_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shopping_lists/1 or /shopping_lists/1.json
  def destroy
    @shopping_list.destroy!

    respond_to do |format|
      format.html { redirect_to shopping_lists_url, notice: 'Shopping list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_shopping_list
    @shopping_list = ShoppingList.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def shopping_list_params
    params.require(:shopping_list).permit(:item, :level, :quantity)
  end
end
