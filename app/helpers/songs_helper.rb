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
      albums.filter { |album| album.belongs_to?(artists) }
    end

    # Return a 'Default' Album and ensure it has all the artists
    return default_album unless albums

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

  def file_from_params(params = {})
    return unless params[:song]
    return File.new(params[:song][:fi_path]) if params[:song][:fi_path]
    return nil unless params[:song][:song]
    return params[:song][:song].tempfile
  end

  # artists: artists, album: album, song: song, file: fi
  def upload_song(song, fi)
    s3 = SessionsHelper::S3Client.new()
    s3.upload({id: song.id, name: song.name, file: fi})

    # Save urls
    song.url = s3.url
    song.lossless_url = s3.lossless_url
    song.save
  end

  # {artists: artists, album: album, song: song, file: fi}
  def update_song(song, fi)
    s3 = SessionsHelper::S3Client.new()
    s3.update({id: song.id, name: song.name, file: fi})

    # Save urls
    song.url = s3.url
    song.lossless_url = s3.lossless_url
    song.save
  end

  def delete_song(song)
    s3 = SessionsHelper::S3Client.new()
    s3.delete({id: song.id, name: song.name, url: song.url})
  end

end
