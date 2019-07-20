class PlaylistsController < ApplicationController
  include PlaylistsHelper
  include Orderable
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    @playlists = Playlist.paginate(page: params[:page]).order(ordering_params(params)).all

    if logged_in?
      @editing = params[:editing]
      @deleting = params[:deleting]
    end

    gon.playlists = @playlists
    respond_to do |format|
      format.js { render '_index.js.erb' }
      format.html { render :index }
      format.json { render :json => @playlists.to_json(include: [:songs]) }
    end
  end

  def show
    @playlist = Playlist.find(params[:id])

    respond_to do |format|
      if @playlist
        @songs = []
        @playlist.playlist_songs.order(:track_order).each { |s| @songs.append(s.song) }
        gon.songs = @songs
        format.html { render :show }
        format.json { render :json => @playlist.to_json(include: [:songs]) }
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
    playlist = Playlist.new(playlist_params)
    songs = songs_from_params(params)
    playlist.songs << songs
    playlist.playlist_songs.each_with_index do |playlist_song, index|
      playlist_song.track_order = songs.index { |s| s.id == playlist_song.song_id }
    end

    respond_to do |format|
      if playlist.save
        format.html { redirect_to playlist_url(playlist) and return }
        format.json { render :json => playlist.to_json(include: [:songs]) }
      else
        format.html { flash.now[:danger] = "#{playlist.errors.messages}"; render :new }
        format.html { render :json => { :error => "#{playlist.errors.messages}" }, :status => 400 }
      end
    end
  end

  def edit
    @playlist = Playlist.find(params[:id])

    if @playlist
      @song_ids = @playlist.playlist_songs.order(:track_order).map { |s| s.song_id }.join(",")
      render :edit
    else
      render :status => 404
    end
  end

  def update
    @playlist = Playlist.find(params[:id])

    respond_to do |format|
      unless @playlist
          format.html { render :status => 404 and return }
          format.json { render :json => [], :status => 400 and return }
      end

      @playlist.attributes = playlist_params.slice(:name, :description)
      songs = songs_from_params(params)
      @playlist.songs = songs
      @playlist.playlist_songs.each_with_index do |playlist_song, index|
        playlist_song.track_order = songs.index { |s| s.id == playlist_song.song_id }
      end
      if @playlist.save
        format.html { redirect_to playlist_url(@playlist) }
        format.json { render :json => @playlist.to_json(include: [:songs]) }
      else
        format.html { flash.now[:danger] = "#{@playlist.errors.messages}"; render :edit }
        format.json { render :json => { :error => "#{@playlist.errors.messages}" }, :status => 400 }
      end
    end

  end

  def destroy
    @playlist = Playlist.find(params[:id])

    respond_to do |format|
      unless @playlist
        format.html { render :status => 404 and return }
        format.json { render :json => [], :status => 400 and return }
        return
      end

      if @playlist.destroy
        format.html { redirect_to playlists_url(deleting: true) }
        format.json { render :json => @playlist.to_json(include: [:songs]) }
      else
        format.html { flash.now[:danger] = "#{@playlist.errors.messages}"; redirect_to playlists_url(deleting: true) }
        format.json { render :json => { :error => "#{@playlist.errors.messages}" }, :status => 400 }
      end
    end
  end

  private

  def playlist_params
    params.require(:playlist).permit(:name, :description)
  end

end
