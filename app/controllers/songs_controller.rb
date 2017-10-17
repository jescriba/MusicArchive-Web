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
      format.json { render :json => @songs.to_json(include: [:artists, :album]) }
    end
  end

  def show
    # TODO search params/pagination
    @song = Song.find(params[:id])

    respond_to do |format|
      if @song
        format.html { render :show }
        format.json { render :json => @song.to_json(include: [:artists, :album]) }
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
    additional_params = { artist_names: params[:song][:artist_names],
                          album_name: params[:song][:album_name],
                          album_id: params[:album_id],
                          uploaded_file: params[:song][:song],
                          file_path: params[:song][:file_path],
                          content_type: content_type_from_params(params) }.compact
    current_params = song_params.merge(additional_params)
    current_params[:recorded_date] = recorded_date_from_params(current_params)
    album = album_from_params(current_params)
    artists = artists_from_params(current_params)
    content_type = content_type_from_params(params)
    file = file_from_params(current_params)
    # Remove params for constructing associations like album_name, artists_names
    song = Song.new(current_params.slice(:name, :description, :recorded_date))
    song.album = album
    song.artists << artists

    respond_to do |format|
      if song.save
        upload_song({ song: song, file: file, content_type: content_type }) if file
        format.html { redirect_to song_url(song) and return }
        format.json { render :json => song.to_json(include: [:artists, :album]) }
      else
        format.html { flash.now[:danger] = "#{song.errors.messages}"; render :new }
        format.html { render :json => { :error => "#{song.errors.messages}" }, :status => 400 }
      end
    end
  end

  def edit
    @song = Song.find(params[:id])

    if @song
      @description = @song.description.empty? ? "Description" : @song.description
      @album_name = @song.album.name || "Album Name"
      @artist_names = ""
      @song.artists.each { |a| @artist_names += a.name + "." }
      @recorded_date = @song.recorded_date

      render :edit
    else
      render :status => 404
    end
  end

  def update
    @song = Song.find(params[:id])

    respond_to do |format|
      unless @song
        format.html { render :status => 404 and return }
        format.json { render :json => [], :status => 400 and return }
        return
      end

      additional_params = { artist_names: params[:song][:artist_names],
                            album_name: params[:song][:album_name],
                            album_id: params[:album_id],
                            uploaded_file: params[:song][:song],
                            file_path: params[:song][:file_path],
                            content_type: content_type_from_params(params) }.compact
      current_params = song_params.merge(additional_params)
      current_params[:recorded_date] = recorded_date_from_params(current_params)
      file = file_from_params(current_params)
      album = album_from_params(current_params)
      artists = artists_from_params(current_params)
      content_type = content_type_from_params(params)
      # Remove params for constructing associations like album_name, artists_names
      @song.attributes = current_params.slice(:name, :description, :recorded_date)
      @song.album = album if album
      @song.artists = artists if artists

      if @song.save
        upload_song({ song: @song, file: file, content_type: content_type }) if file
        format.html { redirect_to song_url(@song) }
        format.json { render :json => @song.to_json(include: [:artists, :album]) }
      else
        format.html { flash.now[:danger] = "#{@song.errors.messages}"; render :edit }
        format.json { render :json => { :error => "#{@song.errors.messages}" }, :status => 400 }
      end
    end
  end

  def destroy
    @song = Song.find(params[:id])

    respond_to do |format|
      unless @song
        format.html { render :status => 404 and return }
        format.json { render :json => [], :status => 400 and return }
        return
      end

      if @song.destroy
        delete_song(@song)
        format.html { redirect_to songs_url(deleting: true) }
        format.json { render :json => @song.to_json(include: [:artists, :album]) }
      else
        format.html { flash.now[:danger] = "#{@song.errors.messages}"; redirect_to songs_url(deleting: true) }
        format.json { render :json => { :error => "#{@song.errors.messages}" }, :status => 400 }
      end
    end
  end

    private

    def song_params
      params.require(:song).permit(:name, :description, :recorded_date)
    end

    def admin_user
      redirect_to(root_url) unless logged_in?
    end
end
