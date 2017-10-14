module SongsHelper
  def artists_from_params(params = {})
    params = params[:song] || params
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
    params = params[:song] || params
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
    params = params[:song] || params
    recorded_date = params[:recorded_date]
    return if recorded_date

    year = params["recorded_date(1i)"]
    month = params["recorded_date(2i)"]
    day = params["recorded_date(3i)"]
    return unless year and month and day

    return Date.parse("#{year}-#{month}-#{day}")
  end

  def file_from_params(params = {})
    return File.new(params[:song][:fi_path]) if params[:song][:fi_path]
    return params[:song][:song].tempfile
  end

  # artists: artists, album: album, song: song, file: fi
  def upload_song(params = {})
    binding.pry
    s3 = SessionsHelper::S3Client.new()
    # hash file and upload song to s3 and resque to convert format
    # Determines if transcoding occurs and queues it up
    # Saves s3 source as hash Digest::MD5.hexdigest(File.read(f))
    s3.upload(fi)
    #s3.should_transcode then trigger

binding.pry
  #  params[:song][:song].content_type
    # Save urls
    song.lossy_url = s3.lossy_url
    song.lossless_url = s3.lossless_url
    song.save
  end
end

# Scratch
#
# def upload_song(file_params, artist_name, song_name)
#   file_type = file_params[:type]
#   lossless_formats = ["audio/x-aiff", "audio/aiff", "audio/x-wav", "audio/wav", "audio/flac"]
#   lossy_formats = ["audio/mp3", "audio/mpeg"]
#   raise "Invalid audio format: #{file_type}" unless (lossless_formats + lossy_formats).include?(file_type)
#
#   base_fi_path = relative_s3_path(artist_name, song_name)
#   base_folder = settings.development? ? "test/" : ""
#   lossy_url = "#{BASE_URL}#{base_folder}music/#{base_fi_path}.mp3"
#   lossless_url = ""
#   extension = File.extname(file_params[:tempfile])
#   if lossless_formats.include?(file_type)
#     lossless_url = "#{BASE_URL}#{base_folder}music/#{base_fi_path}#{extension}"
#   end
#
#   temp_fi_basename = File.basename(file_params[:tempfile], extension)
#
#   # Encode for s3 public url
#   lossy_public_url = public_url(artist_name, song_name, ".mp3", base_folder)
#   lossless_public_url = ""
#   if !lossless_url.empty?
#     lossless_public_url = public_url(artist_name, song_name, extension, base_folder)
#   end
#
#   # Schedule job
#   upload_params = file_params.merge({
#                                       :artist_name => artist_name,
#                                       :song_name => song_name,
#                                       :base_url => BASE_URL,
#                                       :lossy_url => lossy_url,
#                                       :lossless_url => lossless_public_url,
#                                       :is_lossless => !lossless_url.empty?,
#                                    })
#  file_url = upload_params[:is_lossless] ? lossless_public_url : lossy_url
#
#  s3 = Aws::S3::Resource.new(region: 'us-west-1')
#  s3_object_path = file_url.sub(upload_params[:base_url], "")
#  s3_object = s3.bucket(BUCKET).object(s3_object_path)
#
#  # upload
#  s3_object.upload_file(file_params[:tempfile], acl: 'public-read')
#  s3_object.copy_to("#{s3_object.bucket.name}/#{s3_object.key}",
#                          :metadata_directive => "REPLACE",
#                          :acl => "public-read",
#                          :content_type => upload_params[:type],
#                          :content_disposition => "attachment; filename='#{upload_params[:song_name]}#{extension}'")
#   if !lossless_url.empty?
#     Resque.enqueue(SongTranscoder, upload_params)
#   end
#
#   # Return public destination urls
#   [lossy_public_url, lossless_public_url]
# end
#
# def public_url(artist_name, song_name, extension, base_folder)
#   "#{BASE_URL}#{base_folder}music/#{CGI::escape(URI.escape(artist_name))}/#{CGI::escape(URI.escape(song_name))}#{extension}"
# end
