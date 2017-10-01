require 'pry'

class SessionsController < ApplicationController
  def index
    render :index
  end

  def new
    render :new
  end

  def create
    binding.pry
    if username == USERNAME and password == PASSWORD
      #session[:id] = 0
    else
      # Todo error banner
    end
  end

  def destroy
    # Log out
    session[:id] = nil if session[:id]

    redirect_to root_url
  end
end
