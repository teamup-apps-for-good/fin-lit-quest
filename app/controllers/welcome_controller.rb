# frozen_string_literal: true

# Controller for managing logging into the app
class WelcomeController < ApplicationController
  def index
    return unless logged_in?

    redirect_to root_path
  end
end
