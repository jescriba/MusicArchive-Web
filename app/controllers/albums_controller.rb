class AlbumsController < ApplicationController
  include AlbumsHelper
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    # TODO Pagination or search params
    @albums = Album.all

    if logged_in?
      @editing = params[:editing]
      @deleting = params[:deleting]
    end

    respond_to do |format|
      format.html { render :index }
      format.json { render :json => @albums }
    end
  end

  def show
    @album = Album.find(params[:id])

    respond_to do |format|
      if @album
        format.html { render :show }
        format.json { render :json => @album }
      else
        format.html { render :status => 404 }
        format.json { render :json => [], :status => 404 }
      end
    end
  end

  def create
    additional_params = { artist_names: params[:album][:artist_names],
                          tempfiles: params[:album][:album],
                          file_paths: params[:album][:file_paths] }.compact
    current_params = album_params.merge(additional_params)
    current_params[:release_date] = release_date_from_params(current_params)
    files = files_from_params(current_params)
    artists = artists_from_params(current_params)
    # Remove params for constructing associations like album_name, artists_names
    album = Album.new(current_params.slice(:name, :description, :release_date))
    album.artists << artists

    respond_to do |format|
      if album.save
        create_songs_for_album_from_files(album, files) if files
        upload_album(album, files) if files
        format.html { redirect_to album_url(album) and return }
        format.json { render :json => album }
      else
        format.html { flash.now[:danger] = "#{album.errors.messages}"; render :new }
        format.html { render :json => { :error => "#{album.errors.messages}" }, :status => 400 }
      end
    end
  end

  def edit
    redirect_to albums_url and return if params[:id] == "1" # Don't modify Uncategorized

    @album = Album.find(params[:id])

    if @album
      @description = @album.description.empty? ? "Description" : @album.description
      @artist_names = ""
      @album.artists.each { |a| @artist_names += a.name + "." }
      @release_date = @album.release_date

      render :edit
    else
      render :status => 404
    end
  end

  def update
    # Dont modify Uncategorized
    @album = Album.find(params[:id]) unless params[:id] == "1"

    respond_to do |format|
      unless @album
        format.html { render :status => 404 and return }
        format.json { render :json => [], :status => 400 and return }
        return
      end

      additional_params = { artist_names: params[:album][:artist_names],
                            tempfiles: params[:album][:album],
                            file_paths: params[:album][:file_paths] }.compact
      current_params = album_params.merge(additional_params)
      current_params[:release_date] = release_date_from_params(current_params)
      files = files_from_params(current_params)
      artists = artists_from_params(current_params)
      # Remove params for constructing associations like album_name, artists_names
      @album.attributes = current_params.slice(:name, :description, :release_date)
      @album.artists = artists if artists

      if @album.save
        update_album({artists: artists, album: @album, files: files}) if files
        format.html { redirect_to album_url(@album) }
        format.json { render :json => @album }
      else
        format.html { flash.now[:danger] = "#{@album.errors.messages}"; render :edit }
        format.json { render :json => { :error => "#{@album.errors.messages}" }, :status => 400 }
      end
    end
  end

  def destroy
    # Dont modify Uncategorized
    @album = Album.find(params[:id]) unless params[:id] == "1"

    respond_to do |format|
      unless @album
        format.html { render :status => 404 and return }
        format.json { render :json => [], :status => 400 and return }
        return
      end

      if @album.destroy
        delete_album(@album)
        format.html { redirect_to albums_url(deleting: true) }
        format.json { render :json => @album }
      else
        format.html { flash.now[:danger] = "#{@album.errors.messages}"; redirect_to albums_url(deleting: true) }
        format.json { render :json => { :error => "#{@album.errors.messages}" }, :status => 400 }
      end
    end
  end

  private

    def album_params
      params.require(:album).permit(:name, :description)
    end

    def admin_user
      redirect_to(root_url) unless logged_in?
    end
end
