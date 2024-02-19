# frozen_string_literal: true

# Controller for managing omniauth sessions
class SessionsController < ActionController::Base
  def logout
    reset_session
    redirect_to welcome_path, notice: 'You are logged out.'
  end

  def omniauth
    @user = find_or_create_user_from_omniauth

    if @user.valid?
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to welcome_path, alert: 'Login failed.'
    end
  end

  def find_or_create_user_from_omniauth
    auth = request.env['omniauth.auth']
    Character.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
      u.email = auth['info']['email']
      u.name = auth['info']['name']
      u.current_level = 1
    end
  end
end
