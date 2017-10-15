Aws.config.update(
  :region => ENV["S3_REGION"] || 'us-west-2',
  :access_key_id => ENV["S3_ACCESS_KEY"],
  :secret_access_key => ENV["S3_SECRET_KEY"]
)
