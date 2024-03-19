class TutorialsController < ApplicationController
  def show
    @tutorial_level = @current_user.current_level
    @page = params[:page].to_i
  end
end
