# frozen_string_literal: true

# Controller for managing omniauth sessions
class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:login]
  skip_before_action :require_login, only: %i[login logout logged_in omniauth]

  def logout
    reset_session
    redirect_to welcome_path
  end

  def logged_in
    @current_user = current_user
  end

  def omniauth
    user = find_or_create_user_from_omniauth

    if user.valid?
      session[:user_id] = user.id
      redirect_to root_path
    else
      redirect_to welcome_path, alert: 'Login failed.'
    end
  end

  protected

  def find_or_create_user_from_omniauth
    auth = request.env['omniauth.auth']
    Player.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
      u.occupation = :farmer
      u.inventory_slots = 5
      u.balance = 0
      u.email = auth['info']['email']
      u.name = auth['info']['name']
      u.current_level = 1
      u.day = 1
      u.hour = 1
      u.era = 1
    end
  end

  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end
end
