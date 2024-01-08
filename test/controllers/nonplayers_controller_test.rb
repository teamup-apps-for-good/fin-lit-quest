require 'test_helper'

class NonplayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @nonplayer = nonplayers(:one)
  end

  test 'should get index' do
    get nonplayers_url
    assert_response :success
  end

  test 'should get new' do
    get new_nonplayer_url
    assert_response :success
  end

  test 'should create nonplayer' do
    assert_difference('Nonplayer.count') do
      post nonplayers_url,
           params: { nonplayer: { character_id: @nonplayer.character_id, dialogue_id: @nonplayer.dialogue_id,
                                  personality: @nonplayer.personality } }
    end

    assert_redirected_to nonplayer_url(Nonplayer.last)
  end

  test 'should show nonplayer' do
    get nonplayer_url(@nonplayer)
    assert_response :success
  end

  test 'should get edit' do
    get edit_nonplayer_url(@nonplayer)
    assert_response :success
  end

  test 'should update nonplayer' do
    patch nonplayer_url(@nonplayer),
          params: { nonplayer: { character_id: @nonplayer.character_id, dialogue_id: @nonplayer.dialogue_id,
                                 personality: @nonplayer.personality } }
    assert_redirected_to nonplayer_url(@nonplayer)
  end

  test 'should destroy nonplayer' do
    assert_difference('Nonplayer.count', -1) do
      delete nonplayer_url(@nonplayer)
    end

    assert_redirected_to nonplayers_url
  end
end
