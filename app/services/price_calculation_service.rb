# frozen_string_literal: true

# app/services/price_calculation_service.rb
class PriceCalculationService
  def initialize(user, context)
    @user = user
    @context = context
  end

  def calculate_total_price(item_id, quantity, transaction_type)
    Item.find(item_id)
    unit_price = calculate_unit_price(transaction_type, item_id)
    unit_price * quantity
  end

  private

  def calculate_unit_price(transaction_type, item_id)
    if transaction_type == 'buy'
      ValueCalculationService.value_of(@context.character, item_id, 1)
    else
      ValueCalculationService.value_of(@user, item_id, 1)
    end
  end
end
