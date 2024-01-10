class GameplaysController < ApplicationController

  def town
    @characters = Character.all
  end
  
end
