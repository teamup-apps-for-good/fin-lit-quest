class WelcomeController < ApplicationController
  def index
    nil unless logged_in? do
      redirect_to root_path
    end
  end
end
