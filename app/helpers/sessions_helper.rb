module SessionsHelper
  def logged_in?
    return !session[:id].nil?
  end

  class S3Client
    attr_accessor :lossy_url, :lossless_url

    def initialize()
      @lossy_url = nil
      @lossless_url = nil
    end

    def upload(fi)
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
  end
end
