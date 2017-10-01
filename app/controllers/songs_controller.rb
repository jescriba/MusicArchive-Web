class SongsController < ApplicationController
  def index
    respond_to do |format|
      format.html { render :index }
      format.json { render :json => Song.all }
    end
  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destory

  end
end
