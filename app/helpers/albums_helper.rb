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
    # TODO
    return nil
    # return File.new(params[:file_path]) if params[:file_path]
    # return nil unless params[:uploaded_file]
    # return params[:uploaded_file].tempfile
  end


  # artists: artists, album: album, song: song, file: fi
  def upload_album(album, files)
    # TODO
    # s3 = SessionsHelper::S3Client.new()
    # s3.upload({id: song.id, name: song.name, file: files})

    # Save urls
    # song.url = s3.url
    # song.lossless_url = s3.lossless_url
    # song.save
  end

  # {artists: artists, album: album, song: song, file: fi}
  def update_album(album, files)
    # # TODO
    # s3 = SessionsHelper::S3Client.new()
    # s3.update({id: song.id, name: song.name, files: files})

    # Save urls
    # song.url = s3.url
    # song.lossless_url = s3.lossless_url
    # song.save
  end

  def delete_album(album)
    # TODO
    # s3 = SessionsHelper::S3Client.new()
    # s3.delete({id: song.id, name: song.name, url: song.url})
  end

end
