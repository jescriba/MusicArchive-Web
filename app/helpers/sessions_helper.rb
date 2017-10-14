module SessionsHelper
  def logged_in?
    return !session[:id].nil?
  end

  class S3Client
    attr_accessor :lossy_url, :lossless_url

    def initialize()
      @url = nil
      @lossless_url = nil
    end

    def upload(songs)
      binding.pry
    end

    ## FINAL for update/upload s3.upload({id: song.id, name: song.name, file: fi})

    #update_song({artists: artists, album: album, song: song, file: fi}) if fi
    def update(song)
      # todo
      binding.pry
    end

    #s3.delete({id: song.id, name: song.name, url: song.url})
    # s3.delete({id: song.id, name: song.name, file: fi})
    def delete(song)
      binding.pry
    end
  #   # # hash file and upload song to s3 and resque to convert format
  #   # # Determines if transcoding occurs and queues it up
  #   # # Saves s3 source as hash Digest::MD5.hexdigest(File.read(f))
  #   # Digest::MD5.hexdigest(File.read(f))
  #   # Digest::MD5.hexdigest(File.read(f))
  #
  #   s3 = SessionsHelper::S3Client.new()
  #   # hash file and upload song to s3 and resque to convert format
  #   # Determines if transcoding occurs and queues it up
  #   # Saves s3 source as hash Digest::MD5.hexdigest(File.read(f))
  #   s3.upload(fi)
  #
  # #  params[:song][:song].content_type
  #   # Save urls
  #   song.lossy_url = s3.lossy_url
  #   song.lossless_url = s3.lossless_url
  #   song.save
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

  end
end
