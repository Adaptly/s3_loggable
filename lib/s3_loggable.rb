require "fog"
require "s3_loggable/exceptions"
require "s3_loggable/logger"

module S3Loggable

  RequiredCredentials = [:aws_access_key_id, :aws_secret_access_key]

  def self.credentials?
     set_credentials unless (Fog.credentials.keys & RequiredCredentials).count == RequiredCredentials.count
     true
  end

  def self.set_credentials
    if ENV["AWS_ACCESS_KEY_ID"] and ENV["AWS_SECRET_ACCESS_KEY"]
      Fog.credentials[:aws_access_key_id] = ENV["AWS_ACCESS_KEY_ID"]
      Fog.credentials[:aws_secret_access_key] = ENV["AWS_SECRET_ACCESS_KEY"]
    else
      raise ConfigurationError, "Set AWS access key id and secret access key"
    end
  end

  def log_to_s3(bucket, message, id = self.id.to_s, folder = self.class.to_s, date_time = DateTime.now)
    S3Loggable::Logger.new(bucket).log_to_s3(message, id, folder, date_time)
  end

end
