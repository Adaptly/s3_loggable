require "test/unit"
require "mocha/setup"
require "s3_loggable"

class TestS3LoggableLogger < Test::Unit::TestCase

  def test_initialize_existing_bucket
    bucket_name = "test-bucket-name"
    fog_storage = mock("fog_storage")
    bucket = mock("bucket")
    fog_storage_directories = mock("fog_storage_directories")

    fog_storage.expects(:directories).returns(fog_storage_directories)
    fog_storage_directories.expects(:get).with(bucket_name).returns(bucket)
    Fog::Storage.expects(:new).with({:provider => 'AWS'}).returns(fog_storage)
    S3Loggable.expects(:credentials?).returns(true)

    logger = S3Loggable::Logger.new(bucket_name)

    assert_equal(logger.s3, fog_storage) 
    assert_equal(logger.bucket, bucket) 

    logger
  end

  def test_initialize_new_bucket
    bucket_name = "test-bucket-name"
    fog_storage = mock("fog_storage")
    bucket = mock("bucket")
    fog_storage_directories = mock("fog_storage_directories")

    fog_storage.expects(:directories).twice.returns(fog_storage_directories)
    fog_storage_directories.expects(:get).with(bucket_name).returns(nil)
    fog_storage_directories.expects(:create).with(:key => bucket_name).returns(bucket)
    Fog::Storage.expects(:new).with({:provider => 'AWS'}).returns(fog_storage)
    S3Loggable.expects(:credentials?).returns(true)

    logger = S3Loggable::Logger.new(bucket_name)

    assert_equal(logger.s3, fog_storage) 
    assert_equal(logger.bucket, bucket) 

    logger
  end

  def test_log_to_s3_new_log
    logger = test_initialize_existing_bucket
    message = {'foo' => 'bar'}
    test_object = 'test-object'
    id = 123
    s3_file = mock('s3_file')
    s3_files = mock('s3_files')

    logger.bucket.expects(:files).twice.returns(s3_files)
    s3_files.expects(:get).returns(nil)
    s3_files.expects(:create).returns(s3_file)
    s3_file.expects(:body)
    s3_file.expects(:body=)
    s3_file.expects(:save)
    assert_equal(logger.log_to_s3(message, id, test_object), s3_file)
  end

  def test_log_to_s3_existing_log
    logger = test_initialize_existing_bucket
    message = {'foo' => 'bar'}
    test_object = 'test-object'
    id = 123
    deflated_string = Zlib::Deflate.deflate(message.to_s)
    s3_file = mock('s3_file')
    s3_files = mock('s3_files')

    logger.bucket.expects(:files).returns(s3_files)
    s3_files.expects(:get).returns(s3_file)
    s3_file.expects(:body).returns(deflated_string)
    s3_file.expects(:body=)
    s3_file.expects(:save)
    assert_equal(logger.log_to_s3(message, id, test_object), s3_file)
  end

end
