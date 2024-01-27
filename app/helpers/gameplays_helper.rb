# frozen_string_literal: true

# GameplaysHelper
module GameplaysHelper
  def nonplayer_gif_exists?(nonplayer)
    path = "#{nonplayer.name.downcase}.gif"
    if Rails.application.assets
      !Rails.application.assets.find_asset(path).nil?
    else
      !Rails.application.assets_manifest.find_sources(path).nil?
    end
  end

  def nonplayer_gif_file(nonplayer)
    if nonplayer_gif_exists?(nonplayer)
      "#{nonplayer.name.downcase}.gif"
    else
      'generic_nonplayer.gif'
    end
  end

  def nonplayer_img_tag(nonplayer)
    "#{nonplayer.name.downcase}.gif"
  end
end
