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
    user, is_new_user = find_or_create_user_from_omniauth
    if user.valid?
      session[:user_id] = user.id
      redirect_to is_new_user ? tutorial_path(1) : root_path
    end
  rescue NoMethodError
    redirect_to welcome_path, alert: 'Login failed.'
  end

  protected

  def find_or_create_user_from_omniauth
    auth = request.env['omniauth.auth']
    user = Player.find_by(uid: auth['uid'], provider: auth['provider'])
    is_new_user = user.nil?

    if is_new_user
      user = Player.create(uid: auth['uid'], provider: auth['provider']) do |u|
        set_user_attributes(u, auth)
        u.add_starter_items
      end
    end

    [user, is_new_user]
  end

  def set_user_attributes(user, auth_info)
    user.occupation = :farmer
    user.inventory_slots = 5
    user.balance = 0
    user.email = auth_info['info']['email']
    user.name = auth_info['info']['name']
    user.current_level = 1
    user.hour = 1
    user.day = 1
  end

  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end
end
