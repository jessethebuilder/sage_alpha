  Aws.config.update({
    region: ENV['AWS_REGION'],
    credentials: Aws::Credentials.new(ENV['AWS_ID'], ENV['AWS_SECRET']),
  })

  S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['AWS_BUCKET'])
