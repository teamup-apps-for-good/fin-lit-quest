# frozen_string_literal: true

# CounterOfferController handles the actions related to counter offers.
class CounterOfferController < ApplicationController
  def show
    @name = params[:name]
    @character = Character.find_by(name: @name)
    @counter_offer = CounterOffer.new
    @player_character = Character.find_by(type: "Player")
    @player_inventory = inventory_for(@player_character)
    @npc_inventory = inventory_for(@character)
    Rails.logger.debug "Character: #{@character}"
    Rails.logger.debug "Player Character: #{@player_character}"
  end

  def create
    @counter_offer = CounterOffer.new(counter_offer_params)
    @name = params[:name]
    @character = Character.find_by(name: @name)
    @player_character = Character.find_by(type: "Player")
    handle_counter_offer
  end

  def handle_successful_offer
    return unless @counter_offer.save
  
    if @player_character.nil? || @character.nil?
      flash[:alert] = 'An error occurred: character not found.'
      redirect_to request.referer || fallback_path
    return
    end
  
    ActiveRecord::Base.transaction do
      update_inventory(@player_character, @counter_offer.item_i_give_id, -@counter_offer.quantity_i_give)
      update_inventory(@player_character, @counter_offer.item_i_want_id, @counter_offer.quantity_i_want)
      update_inventory(@character, @counter_offer.item_i_want_id, -@counter_offer.quantity_i_want)
      update_inventory(@character, @counter_offer.item_i_give_id, @counter_offer.quantity_i_give)
    end
  
    flash[:notice] = 'Success!'
    redirect_to counter_offer_path(name: @name)
  end
  
  private
  
  def inventory_for(character)
    character.inventories.includes(:item).each_with_object({}) do |inventory, hash|
      hash[inventory.item.name] = inventory.quantity
    end
  end

  def handle_counter_offer
    return handle_missing_fields if missing_required_fields?(@counter_offer)
    return handle_invalid_trade unless valid_trade?(@counter_offer)
    return handle_npc_item_shortage unless npc_has_item?(@character, @counter_offer.item_i_want_id,
                                                         @counter_offer.quantity_i_want)
    handle_successful_offer
  end

  def handle_missing_fields
    flash[:alert] = 'Please fill in all required fields'
    redirect_to request.referer || fallback_path
  end

  def counter_offer_params
    params.require(:counter_offer).permit(:item_i_give_id, :quantity_i_give, :item_i_want_id, :quantity_i_want)
  end

  def handle_invalid_trade
    flash[:notice] = "#{@name} did not accept your offer!"
    redirect_to request.referer || fallback_path
  end

  def handle_npc_item_shortage
    flash[:alert] = "#{@name} does not have the item you are trying to get"
    redirect_to request.referer || fallback_path
  end

  def valid_trade?(counter_offer)
    value_of_given_items = calculate_total_value(counter_offer.item_i_give_id, counter_offer.quantity_i_give)
    value_of_wanted_items = calculate_total_value(counter_offer.item_i_want_id, counter_offer.quantity_i_want)

    value_of_given_items >= value_of_wanted_items
  end

  def calculate_total_value(item_id, quantity)
    item = Item.find_by(id: item_id)
    return 0 unless item && quantity.present? && quantity.to_i.positive?

    item.value * quantity.to_i
  end

  def missing_required_fields?(counter_offer)
    counter_offer.item_i_give_id.blank? || counter_offer.quantity_i_give.blank? ||
      counter_offer.item_i_want_id.blank? || counter_offer.quantity_i_want.blank?
  end

  def npc_has_item?(character, item_id, quantity)
    inventory_item = character.inventories.find_by(item_id:)
    inventory_item && inventory_item.quantity >= quantity
  end

  def update_inventory(character, item_id, quantity_change)
    Rails.logger.debug "Updating inventory for item ID: #{item_id}" # This line logs the item ID
  
    inventory_item = character.inventories.find_by(item_id: item_id)
    
    if inventory_item.nil?
      inventory_item = Inventory.create(item: Item.find(item_id), character: character, quantity: quantity_change)
      return
    end
    
    inventory_item.quantity += quantity_change
    inventory_item.save
  end
  

end
