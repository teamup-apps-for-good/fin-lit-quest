# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def current_user
    # if @current _user is undefined or falsy, evaluate the RHS
    #   RHS := look up user by id only if user id is in the session hash
    @current_user ||= Character.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    # A character session exists, but they do not exist in the database
    # Likely to happen if cookies aren't cleared after a db reset
    reset_session
    redirect_to welcome_path
  end

  def logged_in?
    # current_user returns @current_user,
    #   which is not nil (truthy) only if session[:user_id] is a valid user id
    current_user
  end

  def require_login
    # redirect to the welcome page unless user is logged in
    unless logged_in? or request.path == welcome_path
      redirect_to welcome_path, alert: 'You must be logged in to access this section.'
    end
  end
end
