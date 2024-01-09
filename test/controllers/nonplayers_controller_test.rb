require "test_helper"

class NonplayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @nonplayer = nonplayers(:one)
  end

  test "should get index" do
    get nonplayers_url
    assert_response :success
  end

  test "should get new" do
    get new_nonplayer_url
    assert_response :success
  end

  test "should create nonplayer" do
    assert_difference("Nonplayer.count") do
      post nonplayers_url, params: { nonplayer: { dialogue_content: @nonplayer.dialogue_content, item_to_accept: @nonplayer.item_to_accept, item_to_offer: @nonplayer.item_to_offer, personality: @nonplayer.personality, quantity_to_accept: @nonplayer.quantity_to_accept } }
    end

    assert_redirected_to nonplayer_url(Nonplayer.last)
  end

  test "should show nonplayer" do
    get nonplayer_url(@nonplayer)
    assert_response :success
  end

  test "should get edit" do
    get edit_nonplayer_url(@nonplayer)
    assert_response :success
  end

  test "should update nonplayer" do
    patch nonplayer_url(@nonplayer), params: { nonplayer: { dialogue_content: @nonplayer.dialogue_content, item_to_accept: @nonplayer.item_to_accept, item_to_offer: @nonplayer.item_to_offer, personality: @nonplayer.personality, quantity_to_accept: @nonplayer.quantity_to_accept } }
    assert_redirected_to nonplayer_url(@nonplayer)
  end

  test "should destroy nonplayer" do
    assert_difference("Nonplayer.count", -1) do
      delete nonplayer_url(@nonplayer)
    end

    assert_redirected_to nonplayers_url
  end
end
