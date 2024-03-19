class TutorialsController < ApplicationController
  def show
    @tutorial_level = @current_user.current_level
    @page = params[:page].present? ? params[:page].to_i : 1
  end
end
