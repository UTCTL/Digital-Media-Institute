CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => S3SwfUpload::S3Config.access_key_id,
    :aws_secret_access_key  => S3SwfUpload::S3Config.secret_access_key
  }
  config.fog_directory  = S3SwfUpload::S3Config.bucket
end
