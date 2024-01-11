# frozen_string_literal: true

# Actions for the Inventory table.
class InventoriesController < ApplicationController
  before_action :set_inventory, only: %i[show edit update destroy]

  # GET /inventories or /inventories.json
  def index
    @inventories = Inventory.all
  end

  # GET /inventories/1 or /inventories/1.json
  def show; end

  # GET /inventories/new
  def new
    @inventory = Inventory.new
  end

  # GET /inventories/1/edit
  def edit; end

  # POST /inventories or /inventories.json
  def create
    begin
      new_params = {
        item: Item.find(Integer(inventory_params['item'])),
        character: Character.find(Integer(inventory_params['character'])),
        quantity: inventory_params['quantity']
      }
    rescue
      redirect_to new_inventory_path
      return
    end
    if new_params[:item].nil? || new_params[:character].nil? || new_params[:quantity].nil?
      redirect_to new_inventory_path
      return
    end
    @inventory = Inventory.new(new_params)

    respond_to do |format|
      if @inventory.save
        format.html { redirect_to inventory_url(@inventory), notice: 'Inventory was successfully created.' }
        format.json { render :show, status: :created, location: @inventory }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventories/1 or /inventories/1.json
  def update
    respond_to do |format|
      if @inventory.update({
                             item: !inventory_params['item'].nil? && !(inventory_params['item'] == '') && Item.find(Integer(inventory_params['item'])),
                             character: !inventory_params['character'].nil? && !(inventory_params['character'] == '') && Character.find(Integer(inventory_params['character'])),
                             quantity: inventory_params['quantity']
                           })
        format.html { redirect_to inventory_url(@inventory), notice: 'Inventory was successfully updated.' }
        format.json { render :show, status: :ok, location: @inventory }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventories/1 or /inventories/1.json
  def destroy
    @inventory.destroy!

    respond_to do |format|
      format.html { redirect_to inventories_url, notice: 'Inventory was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_inventory
    @inventory = Inventory.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def inventory_params
    params.require(:inventory).permit(:item, :character, :quantity)
  end
end
