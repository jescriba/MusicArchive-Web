class SongsController < ApplicationController
  include SongsHelper
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    # # TODO Pagination
    @songs = Song.all

    if logged_in?
      @editing = params[:editing]
      @deleting = params[:deleting]
    end

    respond_to do |format|
      format.html { render :index }
      format.json { render :json => @songs }
    end
  end

  def show
    # TODO search params/pagination
    @song = Song.find(params[:id])

    respond_to do |format|
      if @asong
        format.html { render :show }
        format.json { render :json => @song }
      else
        format.html { render :status => 404 }
        format.json { render :json => [], :status => 404 }
      end
    end
  end

  def new
    render :new
  end

  def create
    params[:recorded_date] = recorded_date_from_params(params)
    album = album_from_params(params)
    song = Song.new(song_params)
    song.album = album
    artists = artists_from_params(params)

    respond_to do |format|
      if song.save
        fi = file_from_params(params)
        upload_song({artists: artists, album: album, song: song, file: fi})
        format.html { redirect_to song_url(song) and return }
        format.json { render :json => song }
      else
        format.html { flash.now[:danger] = "#{song.errors.messages}"; render :new }
        format.html { render :json => { :error => "#{song.errors.messages}" }, :status => 400 }
      end
    end
  end

  def edit
    # @artist = Artist.find(params[:id])
    #
    # if @artist
    #   @description = @artist.description.empty? ? "Description" : @artist.description
    #
    #   render :edit
    # else
    #   render :status => 404
    # end
  end

  def update
    # @artist = Artist.find(params[:id])
    #
    # respond_to do |format|
    #   unless @artist
    #     format.html { render :status => 404 and return }
    #     format.json { render :json => [], :status => 400 and return }
    #   end
    #
    #   @artist.attributes = artist_params
    #
    #   if @artist.save
    #     format.html { redirect_to artist_url(@artist) }
    #     format.json { render :json => @artist }
    #   else
    #     format.html { flash.now[:danger] = "#{@artist.errors.messages}"; render :edit }
    #     format.json { render :json => { :error => "#{@artist.errors.messages}" }, :status => 400 }
    #   end
    # end
  end

  def destroy
    # @artist = Artist.find(params[:id])
    #
    # respond_to do |format|
    #   unless @artist
    #     format.html { render :status => 404 and return }
    #     format.json { render :json => [], :status => 400 and return }
    #   end
    #
    #   if @artist.destroy
    #     format.html { redirect_to artists_url(deleting: true) }
    #     format.json { render :json => @artist }
    #   else
    #     format.html { flash.now[:danger] = "#{@artist.errors.messages}"; redirect_to artists_url(deleting: true) }
    #     format.json { render :json => { :error => "#{@artist.errors.messages}" }, :status => 400 }
    #   end
    # end
  end

    private

    def song_params
      params.require(:song).permit(:name, :description, :recorded_date)
    end

    def admin_user
      redirect_to(root_url) unless logged_in?
    end
end
