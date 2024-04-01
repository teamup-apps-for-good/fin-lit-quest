# frozen_string_literal: true

# GameplaysHelper
module GameplaysHelper
  def nonplayer_gif_exists?(nonplayer)
    path = "#{nonplayer.name.downcase}.gif"
    !(Rails.application.assets || ::Sprockets::Railtie.build_environment(Rails.application)).find_asset(path).nil?
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

  def get_player_name(player)
    if player.firstname.nil?
        return player.name
    else
        return player.firstname
    end
  end
end
