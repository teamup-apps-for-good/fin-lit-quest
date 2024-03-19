class TutorialsController < ApplicationController
  def show
    @tutorial_level = @current_user.current_level
    @page = params[:page].present? ? params[:page].to_i : 1
    if @tutorial_level == 1
      @last_page = 6
    elsif @tutorial_level == 2
      @last_page = 7
    else
      @last_page = 1
    end
  end
end
