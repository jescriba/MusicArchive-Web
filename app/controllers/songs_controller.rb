class SongsController < ApplicationController
  include SongsHelper
  include Orderable
  protect_from_forgery prepend: true
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  has_scope :by_name, only: :index
  has_scope :by_description, only: :index
  has_scope :by_created_at, using: [:from, :to], only: :index
  has_scope :by_updated_at, using: [:from, :to], only: :index
  has_scope :by_recorded_date, using: [:from, :to], only: :index

  def index
    ## API sort=-created_at,name
    ## API filter by_name=something&by_description=something&by_recorded_date[from]=yyyy-mm-dd&by_recorded_date[to]=yyyy-mm-dd
    search_params = params.permit(:album_id)
    ordering_params = ordering_params(params)
    if params[:artist_id]
      # Handle /artists/:id/songs route
      a = Artist.find params[:artist_id]
      @songs = a.songs
                .order(ordering_params)
                .all
    elsif search_params.empty?
      @songs = apply_scopes(Song)
                   .paginate(page: params[:page])
                   .order(ordering_params)
                   .all
    else
      @songs = apply_scopes(Song)
                   .find_by(search_params)
                   .paginate(page: params[:page])
                   .order(ordering_params)
                   .all
    end
    @songs = [].push(@songs) if @songs.class == Song

    if logged_in?
      @editing = params[:editing]
      @deleting = params[:deleting]
    end

    gon.songs = @songs
    respond_to do |format|
      format.js { render '_index.js.erb' }
      format.html { render :index }
      format.json { render :json => @songs.to_json(include: [:artists, :album]) }
    end
  end

  def show
    @song = Song.find(params[:id])

    respond_to do |format|
      if @song
        gon.songs = [@song]
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
    additional_params = { artist_names: params[:song][:artist_names] || params[:artist_names],
                          album_name: params[:song][:album_name] || params[:album_name],
                          album_id: params[:album_id],
                          uploaded_file: params[:song][:song],
                          file_path: params[:song][:file_path],
                          remote_file_path: params[:song][:remote_file_path],
                          content_type: content_type_from_params(params) }.compact
    current_params = song_params.merge(additional_params)
    current_params[:recorded_date] = recorded_date_from_params(current_params)
    album = album_from_params(current_params)
    artists = artists_from_params(current_params)
    content_type = content_type_from_params(current_params)
    file = file_from_params(current_params)
    # Remove params for constructing associations like album_name, artists_names
    song = Song.new(current_params.slice(:name, :description, :recorded_date))
    song.album = album
    song.artists << artists
    puts "Saving params: #{current_params} in song: #{song} with album: #{album} and artists: #{artists} with file: #{file}"

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
      @description = @song.description ? "Description" : @song.description
      @album_name = @song.album.name || "Album Name"
      @artist_names = ""
      @song.artists.each { |a| @artist_names += a.name + "," }
      # Remove trailing comma
      @artist_names = @artist_names.chomp ","
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

      additional_params = { artist_names: params[:artist_names],
                            album_name: params[:album_name],
                            album_id: params[:album_id],
                            uploaded_file: params[:song][:song],
                            file_path: params[:song][:file_path],
                            content_type: content_type_from_params(params) }.compact
      current_params = song_params.merge(additional_params)
      current_params[:recorded_date] = recorded_date_from_params(current_params)
      new_name = current_params[:name]
      file = file_from_params(current_params)
      album = album_from_params(current_params)
      artists = artists_from_params(current_params)
      content_type = content_type_from_params(params)
      # Remove params for constructing associations like album_name, artists_names
      should_update_storage_name = true if !file and @song.name != new_name and new_name
      @song.attributes = current_params.slice(:name, :description, :recorded_date)
      @song.album = album if album
      @song.artists = artists if artists

      if @song.save
        # Update the content-dispoisiton of s3 resource if the name changes
        # without a  new uploaded file
        update_storage_name({ song: @song }) if should_update_storage_name
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
end
