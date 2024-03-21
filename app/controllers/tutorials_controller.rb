# frozen_string_literal: true

# TutorialsContrller
class TutorialsController < ApplicationController
  def show
    @tutorial_level = @current_user.current_level
    @page = params[:page].present? ? params[:page].to_i : 1
    last_page_for_level = { 1 => 6, 2 => 7 }
    @last_page = last_page_for_level[@tutorial_level] || 1
  end
end
