require "test/unit"
require "mocha/setup"
require "s3_loggable"

class TestS3LoggableConfiguration < Test::Unit::TestCase

  def test_default_configurations_are_nil
    assert_nil(S3Loggable.configuration.aws_access_key_id) 
    assert_nil(S3Loggable.configuration.aws_secret_access_key) 
    assert_nil(S3Loggable.configuration.default_bucket) 
  end

  def test_paramaters_can_be_set_and_accessed
    key = "ABC"
    secret = "123"
    bucket = "foo-bar"

    S3Loggable.configure do |config|
      config.aws_access_key_id = key
      config.aws_secret_access_key = secret
      config.default_bucket = bucket
    end

    assert_equal(S3Loggable.configuration.aws_access_key_id, key)
    assert_equal(S3Loggable.configuration.aws_secret_access_key, secret) 
    assert_equal(S3Loggable.configuration.default_bucket, bucket)
  end

end
