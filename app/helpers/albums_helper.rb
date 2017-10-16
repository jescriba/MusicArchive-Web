module AlbumsHelper
  include SongsHelper

  def release_date_from_params(params = {})
    release_date = params[:release_date]
    return if release_date

    year = params["release_date(1i)"]
    month = params["releae_date(2i)"]
    day = params["release_date(3i)"]
    return unless year and month and day

    return Date.parse("#{year}-#{month}-#{day}")
  end

  def files_from_params(params = {})
    if params[:file_paths]
      files = []
      params[:file_paths].each do |file_path|
        files.push File.new file_path
      end
      return files
    end
    return nil unless params[:uploaded_files]
    return params[:uploaded_files].map { |fi| fi.tempfile }
  end

  def file_names_from_params(params = {})
    if params[:file_paths]
      file_names = []
      params[:file_paths].each do |file_path|
        file_names.push File.basename file_path
      end
      return file_names
    end
    return nil unless params[:uploaded_files]
    return params[:uploaded_files].map { |fi| fi.original_filename }
  end

  # artists: artists, album: album, song: song, file: fi
  #upload_album({ songs: songs, files: files }) if files
  def upload_album(params = {})
    return unless params[:songs] and params[:files]
    files = params[:files]
    songs = params[:songs]
    return unless files.count == songs.count and files.count > 0

    songs.each_with_index do |song, index|
      file = files[index]
      content_type = StorageClient.content_type_from_extension(File.extname(file))
      upload_song({ song: song, file: file, content_type: content_type })
    end
  end

  def delete_album(album)
    return unless album
    album.songs.each do |song|
      delete_song(song)
    end
  end

  def create_songs_from_file_names_and_artists(file_names, artists)
    songs = []
    file_names.each do |file_name|
      name = File.basename(file_name, ".*")
      song = Song.new name: name
      song.artists << artists
      begin
        recorded_date = /(\d{2})-(\d{2})-(\d{4})/.match(name)
        year = recorded_date[3]
        month = recorded_date[1]
        day = recorded_date[2]
        recorded_date = Date.parse("#{year}-#{month}-#{day}")
        song.recorded_date = recorded_date
      rescue
      end
      songs.push song
    end
    return songs
  end

end
