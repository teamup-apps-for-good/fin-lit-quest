# frozen_string_literal: true

# Provides validation methods for counter offer parameters
module CounterOfferValidations
  extend ActiveSupport::Concern

  private

  def validate_counter_offer_params
    params[:item_i_give_id].present? && params[:quantity_i_give].present? &&
      params[:item_i_want_id].present? && params[:quantity_i_want].present?
  end

  def validate_buy_params
    params[:item_i_want_id].present? && params[:quantity_i_want].present?
  end

  def validate_sell_params
    params[:item_i_give_id].present? && params[:quantity_i_give].present?
  end
end
