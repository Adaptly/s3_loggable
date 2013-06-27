require "date"
require "zlib"

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

    def log_to_s3(message, folder, id, date_time = DateTime.now)
      filename = "%s/%s/%04d/%02d/%02d%s" % [folder, id, date_time.year, date_time.month, date_time.day, ".rb.gz"]
      temp_filename = "tmp/#{filename}"
      file = get_log(filename)
      file = create_log(filename, temp_filename) unless file
      write_to_log(filename, message, date_time, file, temp_filename)
    end

    def write_to_log(filename, message, date_time, file, temp_filename)
      local_file = File.open(temp_filename, 'w')
      local_file.write(file.body)
      local_file.close
      File.open(temp_filename, "a+") do |file_gz_io|
       	Zlib::GzipWriter.wrap(file_gz_io) do |file_gz|
	  file_gz.puts date_time.to_s
	  file_gz.puts message.to_s
	  file_gz.puts
	end
      end
      file.body = File.open(temp_filename)
      file.save
      File.delete(local_file)
      file
    end

    def get_log(filename)
      file = @bucket.files.get(filename)
      file
    end

    def create_log(filename, temp_filename)
      file = @bucket.files.create(:key => filename,
				  :content_type => "application/gzip")
      FileUtils.mkdir_p(File.dirname(temp_filename))
      temp_file = File.new(temp_filename, 'w')
      temp_file.close
      file
    end

  end
end
