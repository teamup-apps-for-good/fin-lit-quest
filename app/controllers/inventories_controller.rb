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
    new_params = {
      item: Item.find_by(name: inventory_params['item']),
      character: Character.find_by(name: inventory_params['character']),
      quantity: inventory_params['quantity']
    }
    @inventory = Inventory.new(new_params)
    # begin
    #
    # rescue StandardError
    #   redirect_to new_inventory_path
    #   return
    # end

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
      updates = create_updates(inventory_params)
      if updates.nil?
        redirect_to edit_inventory_path(@inventory)
        return
      end
      if @inventory.update(updates)
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

  def create_updates(inventory_params)
    updates = {}
    if inventory_params['item'].to_s != ''
      updates[:item] = Item.find(Integer(inventory_params['item']))
      return if updates[:item].nil?
    end
    if inventory_params['character'].to_s != ''
      updates[:character] =
        Character.find(Integer(inventory_params['character']))
      return if updates[:character].nil?
    end
    updates[:quantity] ||= inventory_params['quantity']
    return unless updates[:quantity] && Integer(updates[:quantity]).positive?

    updates
  end

  # Only allow a list of trusted parameters through.
  def inventory_params
    params.require(:inventory).permit(:item, :character, :quantity)
  end
end
