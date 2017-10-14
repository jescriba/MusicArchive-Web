class AlbumsController < ApplicationController
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
    # TODO
    album = Album.new(album_params)

    respond_to do |format|
      if album.save
        format.html { redirect_to album_url(album) and return }
        format.json { render :json => album }
      else
        format.html { flash.now[:danger] = "#{album.errors.messages}"; render :new }
        format.json { render :json => { :error => "#{album}.errors.messages}" }, :status => 400 }
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

    def album_params
      params.require(:album).permit(:name, :description)
    end

    def admin_user
      redirect_to(root_url) unless logged_in?
    end
end
