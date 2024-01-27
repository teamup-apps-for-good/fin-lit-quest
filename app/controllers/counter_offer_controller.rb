# frozen_string_literal: true

# CounterOfferController handles the actions related to counter offers.
class CounterOfferController < ApplicationController
  def show
    @name = params[:name]
    @character = Character.find_by(name: @name)
    @counter_offer = CounterOffer.new
  end

  def create
    @counter_offer = CounterOffer.new(counter_offer_params)
    @name = params[:name] # Set @name based on the parameter
    @character = Character.find_by(name: @name) # Set @character based on @name
    if @counter_offer.save
      flash[:notice] = 'Success!' # Set the flash notice message
      redirect_to counter_offer_path(@name) # Redirect using @name
    else
      # Handle validation errors or other cases
      render :show
    end
  end

  private

  def counter_offer_params
    params.require(:counter_offer).permit(:item_i_give, :quantity_i_give, :item_i_want, :quantity_i_want)
  end
end
