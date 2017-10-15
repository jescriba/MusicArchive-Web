# Could be cool to have this implemented as an interface so people could switch out s3
class StorageClient
  attr_accessor :url, :lossless_url, :resource_name, :content_type
  # Supported Formats
  @@lossless_formats = ["audio/x-aiff", "audio/aiff", "audio/x-wav", "audio/wav", "audio/flac"]
  @@lossy_formats = ["audio/mp3", "audio/mpeg"]
  BUCKET = ENV["S3_BUCKET"]
  BASE_URL = ENV["S3_BASE_URL"]

  def initialize()
    @url = nil
    @lossless_url = nil
    @resource_name = nil
    @content_type = nil
  end

  def should_transcode?
    is_lossless
  end

  # { song: @song, file: file, content_type: content_type }
  def upload(params = {})
    file = params[:file]
    @content_type = params[:content_type]
    song = params[:song]
    extension = File.extname(file)
    raise "Invalid audio format: #{content_type}" unless is_valid_content_type

    # Check if we are updating an existing stored song
    previous_url = existing_url(song)

    @resource_name = "#{Digest::MD5.hexdigest(File.read(file))}#{extension}"
    s3 = Aws::S3::Resource.new
    s3_object = s3.bucket(BUCKET).object(@resource_name)

    # TODO Handle file privacy
    s3_object.upload_file(file, acl: 'public-read')
    s3_object.copy_to("#{s3_object.bucket.name}/#{s3_object.key}",
                       :metadata_directive => "REPLACE",
                       :acl => "public-read",
                       :content_type => @content_type,
                       :content_disposition => "attachment; filename='#{song.name}#{extension}'")

    public_url = s3_object.public_url
    is_lossless ? @lossless_url = public_url : @lossy_url = public_url

    return unless previous_url

    # Delete previous version of song in storage
    params[:url] = public_url
    delete(params)
  end

  def delete(params = {})
    return unless params[:url]

    binding.pry
    url = params[:url].split("/").last
    s3 = Aws::S3::Resource.new
    obj = s3.bucket(BUCKET).object(resource_name)
    obj.delete()
  end

  private
    def is_valid_content_type
      (@@lossless_formats + @@lossy_formats).include?(@content_type)
    end

    def is_lossless
      @@lossless_formats.include?(@content_type)
    end

    def existing_url(song)
      # Check if song should already exist on S3 and needs to be deleted
      return song.lossless_url if is_lossless and song.lossless_url

      return song.url
    end
end
