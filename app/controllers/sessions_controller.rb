class SessionsController < ActionController::Base
  def logout
    reset_session
    redirect_to welcome_path, notice: 'You are logged out.'
  end

  def omniauth
    auth = request.env['omniauth.auth']
    @user = Character.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
      # Create the new player in the database
      u.email = auth['info']['email']
      u.name = auth['info']['name']
      u.current_level = 1
    end

    if @user.valid?
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to welcome_path, alert: 'Login failed.'
    end
  end
end
