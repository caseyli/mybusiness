# NOTE: Version 3 of the Gem AUTOMATICALLY uses ENV['AWS_ACCESS_KEY_ID'] and ENV['AWS_SECRET_ACCESS_KEY']
S3_PRESIGNER = Aws::S3::Presigner.new