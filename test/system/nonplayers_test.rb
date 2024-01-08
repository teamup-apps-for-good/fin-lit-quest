# frozen_string_literal: true

require 'application_system_test_case'

class NonplayersTest < ApplicationSystemTestCase
  setup do
    @nonplayer = nonplayers(:one)
  end

  test 'visiting the index' do
    visit nonplayers_url
    assert_selector 'h1', text: 'Nonplayers'
  end

  test 'should create nonplayer' do
    visit nonplayers_url
    click_on 'New nonplayer'

    fill_in 'Character', with: @nonplayer.character_id
    fill_in 'Dialogue', with: @nonplayer.dialogue_id
    fill_in 'Personality', with: @nonplayer.personality
    click_on 'Create Nonplayer'

    assert_text 'Nonplayer was successfully created'
    click_on 'Back'
  end

  test 'should update Nonplayer' do
    visit nonplayer_url(@nonplayer)
    click_on 'Edit this nonplayer', match: :first

    fill_in 'Character', with: @nonplayer.character_id
    fill_in 'Dialogue', with: @nonplayer.dialogue_id
    fill_in 'Personality', with: @nonplayer.personality
    click_on 'Update Nonplayer'

    assert_text 'Nonplayer was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Nonplayer' do
    visit nonplayer_url(@nonplayer)
    click_on 'Destroy this nonplayer', match: :first

    assert_text 'Nonplayer was successfully destroyed'
  end
end
