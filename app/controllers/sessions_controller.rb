require 'pry'

class SessionsController < ApplicationController
  protect_from_forgery prepend: true

  def index
    render :index
  end

  def new
    redirect_to sessions_url and return if session[:id]

    render :new
  end

  def create
    if params[:session][:username] == ENV["USERNAME"] and params[:session][:password] == ENV["PASSWORD"]
      session[:id] = 0
      redirect_to sessions_url and return
    else
      flash.now[:danger] = 'Invalid username/password'
      render :new
    end
  end

  def destroy
    # Log out
    session[:id] = nil if session[:id]

    redirect_to root_url
  end
end
