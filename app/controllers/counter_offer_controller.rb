# frozen_string_literal: true

# Controller for handling counter offers in the game.
class CounterOfferController < ApplicationController
  before_action :set_characters_and_inventories

  def show
    # Setup for show action is handled by before_action
  end

  def create
    if validate_counter_offer(params)
      handle_counter_offer
    else
      flash[:alert] = 'Please fill in all required fields'
      redirect_to request.referer || root_path
    end
  end

  private

  def set_characters_and_inventories
    @name = params[:name]
    @character = Character.find_by(name: @name)
    @player_character = Character.find_by(type: 'Player')
    @player_inventory = inventory_for(@player_character)
    @npc_inventory = inventory_for(@character)
  end

  def inventory_for(character)
    character.inventories.includes(:item).each_with_object({}) do |inventory, hash|
      hash[inventory.item.name] = inventory.quantity
    end
  end

  def handle_counter_offer
    assign_trade_params

    if valid_trade? && npc_has_item?
      execute_trade
      flash[:notice] = 'Success!'
    else
      flash[:alert] = trade_failure_message
    end

    redirect_to counter_offer_path(name: @name)
  end

  def assign_trade_params
    @item_i_give_id = params[:item_i_give_id]
    @quantity_i_give = params[:quantity_i_give].to_i
    @item_i_want_id = params[:item_i_want_id]
    @quantity_i_want = params[:quantity_i_want].to_i
  end

  def valid_trade?
    value_of_given_items >= value_of_wanted_items
  end

  def npc_has_item?
    inventory_item = @character.inventories.find_by(item_id: @item_i_want_id)
    inventory_item && inventory_item.quantity >= @quantity_i_want
  end

  def execute_trade
    ActiveRecord::Base.transaction do
      update_inventory(@player_character, @item_i_give_id, -@quantity_i_give)
      update_inventory(@player_character, @item_i_want_id, @quantity_i_want)
      update_inventory(@character, @item_i_want_id, -@quantity_i_want)
      update_inventory(@character, @item_i_give_id, @quantity_i_give)
    end
  end

  def trade_failure_message
    if !valid_trade?
      "#{@name} did not accept your offer!"
    elsif !npc_has_item?
      "#{@name} does not have the item you are trying to get"
    end
  end

  def validate_counter_offer(params)
    params[:item_i_give_id].present? && params[:quantity_i_give].present? &&
      params[:item_i_want_id].present? && params[:quantity_i_want].present?
  end

  def calculate_total_value(item_id, quantity)
    item = Item.find_by(id: item_id)
    item&.value.to_i * quantity
  end

  def value_of_given_items
    calculate_total_value(@item_i_give_id, @quantity_i_give)
  end

  def value_of_wanted_items
    calculate_total_value(@item_i_want_id, @quantity_i_want)
  end

  def update_inventory(character, item_id, quantity_change)
    inventory_item = character.inventories.find_by(item_id:)

    if inventory_item
      new_quantity = inventory_item.quantity + quantity_change
      update_or_log_error(inventory_item, new_quantity, item_id)
    elsif quantity_change.positive?
      character.inventories.create!(item_id:, quantity: quantity_change)
    end
  end

  def update_or_log_error(inventory_item, new_quantity, item_id)
    unless new_quantity >= 0
      raise NegativeInventoryError, "Invalid quantity for item #{item_id} for character #{inventory_item.character.id}"
    end

    inventory_item.update!(quantity: new_quantity)
  end
end
