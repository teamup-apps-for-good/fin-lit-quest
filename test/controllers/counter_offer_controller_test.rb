# frozen_string_literal: true

require 'test_helper'

class CounterOfferControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get counter_offer_show_url
    assert_response :success
  end
end
