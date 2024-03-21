# frozen_string_literal: true

# TutorialsContrller
class TutorialsController < ApplicationController
  def show
    @tutorial_level = @current_user.current_level
    @page = params[:page].present? ? params[:page].to_i : 1
    @last_page = if @tutorial_level == 1
                   6
                 elsif @tutorial_level == 2
                   7
                 else
                   1
                 end
  end
end
