module S3Loggable
  class Logger
    attr_reader :bucket, :s3

    def initialize(bucket_name)
      @s3 = Fog::Storage.new({:provider => 'AWS'}) if S3Loggable.credentials?
      set_s3_bucket(bucket_name)
    end

    def set_s3_bucket(bucket_name)
      @bucket = @s3.directories.get(bucket_name)
      @bucket = @s3.directories.create(:key => bucket_name) unless @bucket
    end

    def log_to_s3(folder, message, id, time = Time.now)
      
    end

  end
end
