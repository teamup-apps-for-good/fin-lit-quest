# frozen_string_literal: true

# Main application controller that all other controllers should inherit from
class ApplicationController < ActionController::Base
  before_action :require_login

  protected

  def require_login
    redirect_to welcome_path unless logged_in?
  end

  def logged_in?
    current_user.present?
  end

  def current_user
    # if @current _user is undefined or falsy, evaluate the RHS
    #   RHS := look up user by id only if user id is in the session hash
    @current_user ||= Player.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    # A character session exists, but they do not exist in the database
    # Likely to happen if cookies aren't cleared after a db reset
    reset_session
  end
end
