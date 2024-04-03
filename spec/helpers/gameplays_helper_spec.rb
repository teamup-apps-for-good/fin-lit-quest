# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameplaysHelper, type: :helper do
  let(:nonplayer) { double('Nonplayer', name: 'TestNonplayer') }
  let(:nonplayer_with_no_gif) { double('Nonplayer', name: 'NonexistentNonplayer') }

  describe '#nonplayer_gif_exists?' do
    let(:mock_environment) { double('Environment') }

    before do
      allow(Rails.application).to receive(:assets).and_return(nil)
      allow(Sprockets::Railtie).to receive(:build_environment).with(Rails.application).and_return(mock_environment)
      allow(mock_environment).to receive(:find_asset).with('testnonplayer.gif').and_return(double)
      allow(mock_environment).to receive(:find_asset).with('nonexistentnonplayer.gif').and_return(nil)
    end

    it 'returns true if the nonplayer gif exists in assets_manifest' do
      expect(helper.nonplayer_gif_exists?(nonplayer)).to be true
    end

    it 'returns false if the nonplayer gif does not exist in assets_manifest' do
      expect(helper.nonplayer_gif_exists?(nonplayer_with_no_gif)).to be false
    end

    context 'when Rails.application.assets is not available' do
      before do
        allow(Rails.application).to receive(:assets).and_return(nil)
        allow(Rails.application).to receive(:assets_manifest).and_return(double)
      end

      it 'returns true if the nonplayer gif exists in assets_manifest' do
        allow(Rails.application.assets_manifest).to receive(:find_sources)
          .with('testnonplayer.gif').and_return(double)
        expect(helper.nonplayer_gif_exists?(nonplayer)).to be true
      end

      it 'returns false if the nonplayer gif does not exist in assets_manifest' do
        allow(Rails.application.assets_manifest).to receive(:find_sources)
          .with('nonexistentnonplayer.gif').and_return(nil)
        expect(helper.nonplayer_gif_exists?(nonplayer_with_no_gif)).to be false
      end
    end
  end

  describe '#nonplayer_gif_file' do
    it 'returns the specific nonplayer gif if it exists' do
      allow(helper).to receive(:nonplayer_gif_exists?).with(nonplayer).and_return(true)
      expect(helper.nonplayer_gif_file(nonplayer)).to eq('testnonplayer.gif')
    end

    it 'returns the generic nonplayer gif if specific one does not exist' do
      allow(helper).to receive(:nonplayer_gif_exists?).with(nonplayer_with_no_gif).and_return(false)
      expect(helper.nonplayer_gif_file(nonplayer_with_no_gif)).to eq('generic_nonplayer.gif')
    end
  end

  describe '#nonplayer_img_tag' do
    it 'returns the img tag for the nonplayer' do
      expect(helper.nonplayer_img_tag(nonplayer)).to eq('testnonplayer.gif')
    end
  end

  describe '#get_player_name' do
    before do
      Player.create!(name: 'Stella Yang', occupation: :farmer, inventory_slots: 5, balance: 0, current_level: 1,
                     email: 'test@test.com', provider: 'google-oauth2', uid: '1001', admin: true)
      Player.create!(name: 'Emmie Teng', firstname: 'Emmie', occupation: :farmer, inventory_slots: 5, balance: 0,
                     current_level: 1, email: 'test@test.com', provider: 'google-oauth2', uid: '1002', admin: true)
      @stella = Player.find_by(name: 'Stella Yang')
      @emmie = Player.find_by(name: 'Emmie Teng')
    end

    it 'returns name when no first name exists' do
      expect(helper.get_player_name(@stella)).to eq('Stella Yang')
    end

    it 'returns first name when first name exists' do
      expect(helper.get_player_name(@emmie)).to eq('Emmie')
    end
  end
end
