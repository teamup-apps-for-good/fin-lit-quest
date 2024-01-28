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
end
