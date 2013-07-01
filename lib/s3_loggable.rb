require "fog"
require "s3_loggable/exceptions"
require "s3_loggable/logger"
require "s3_loggable/configuration"

module S3Loggable

  RequiredCredentials = [:aws_access_key_id, :aws_secret_access_key]

  def self.credentials?
    set_credentials unless (Fog.credentials.keys & RequiredCredentials).count == RequiredCredentials.count
    true
  end

  def self.set_credentials
    key = (S3Loggable.configuration.aws_access_key_id || ENV["AWS_ACCESS_KEY_ID"])
    secret = (S3Loggable.configuration.aws_secret_access_key || ENV["AWS_SECRET_ACCESS_KEY"])

    if key and secret
      Fog.credentials[:aws_access_key_id] = key
      Fog.credentials[:aws_secret_access_key] = secret
    else
      raise ConfigurationError, "Set AWS access key id and secret access key"
    end
  end

  def log_to_s3(message, bucket = S3Loggable.configuration.default_bucket, id = self.id.to_s,
		folder = self.class.to_s, date_time = DateTime.now)
    S3Loggable::Logger.new(bucket).log_to_s3(message, id, folder, date_time)
  end

end
