# frozen_string_literal: true

# Controller for managing logging into the app
class WelcomeController < ApplicationController
  def index
    nil unless logged_in? do
      redirect_to root_path
    end
  end
end
