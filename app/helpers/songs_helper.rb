module SongsHelper
  def artists_from_params(params = {})
    artist_names = params[:artist_names]
    artist_name = params[:artist_name]
    return nil unless artist_names || artist_name

    artists = []
    if artist_names
      artist_names.split(",").each do |artist_name|
        a = Artist.find_by name: artist_name
        artists.push(a) if a
      end

      return artists
    end

    artist = Artist.find_by name: artist_name
    return [].push(artist) if artist

    return nil
  end

  # An album contains details of the artists
  def album_from_params(params = {})
    album_params = { }
    album_params[:name] = params[:album_name] if params[:album_name]
    album_params[:id] = params[:id] if params[:id]
    albums = Album.find_by album_params unless album_params.empty?
    artists = params[:artists] || artists_from_params(params)
    if artists and albums
      if albums.class == Album
        albums = nil unless albums.artists == artists
        albums = [].push(albums)
      else
        albums.select { |album| album.artists == artists }
      end
    end

    # Return a 'Default' Album and ensure it has all the artists
    return default_album unless albums and albums.first

    return albums.first
  end

  # Default Album for those uploading without an album name
  # Convenience to upload songs into 'Uncategorized'
  def default_album
    return Album.find(1)
  end

  def recorded_date_from_params(params = {})
    recorded_date = params[:recorded_date]
    return if recorded_date

    year = params["recorded_date(1i)"]
    month = params["recorded_date(2i)"]
    day = params["recorded_date(3i)"]
    return unless year and month and day

    return Date.parse("#{year}-#{month}-#{day}")
  end

  def content_type_from_params(params)
    return params[:content_type] if params[:content_type]

    begin
      tempfile = params[:song][:song]
      return tempfile.content_type if tempfile
      return params[:song][:content_type]
    rescue
      return nil
    end
  end

  def file_from_params(params = {})
    return File.new(params[:file_path]) if params[:file_path]
    return nil unless params[:uploaded_file]
    return params[:uploaded_file].tempfile
  end

  # { song: @song, file: file, content_type: content_type }
  def upload_song(params = {})
    return unless params[:song] and params[:file] and params[:content_type]
    file_path = params[:file_path] || params[:file].path
    # Copy Tempfile to Separate Tempfile since Heroku won't persist Tempfile from web request
    extension = File.extname file_path

    tempfile_path = Rails.root.join "tmp/#{SecureRandom.uuid}#{extension}"
    FileUtils.cp file_path, tempfile_path
    song = params[:song]
    content_type = params[:content_type]
    SongsUploadJob.perform_later({song: song, content_type: content_type, file_path: tempfile_path })
  end

  def delete_song(song)
    return unless song
    lossless_url = song.lossless_url
    lossy_url = song.url
    SongsDeleteJob.perform_later({ lossless_url: lossless_url, lossy_url: lossy_url })
  end

end
