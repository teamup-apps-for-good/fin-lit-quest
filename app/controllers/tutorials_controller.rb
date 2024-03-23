class TutorialsController < ApplicationController
  rescue_from ActionView::MissingTemplate, with: :redirect_to_construction

  def show
    @tutorial_level = @current_user.current_level
    @page = params[:page].present? ? params[:page].to_i : 1
    tutorial_levels = YAML.load_file("#{Rails.root}/config/tutorial_levels.yml")
    @last_page = tutorial_levels[@tutorial_level]&.to_i || 1
    render "tutorials/era_#{@tutorial_level}"
  end
  

  private

  def redirect_to_construction
    @tutorial_level = @current_user.current_level
    render "tutorials/era_construction"
  end
end
