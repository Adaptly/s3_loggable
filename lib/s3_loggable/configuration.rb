module S3Loggable
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end
    
    def configure
      yield(self.configuration)
    end
  end
  
  class Configuration
    attr_accessor \
      :aws_access_key_id,
      :aws_secret_access_key,
      :default_bucket

  end
end
