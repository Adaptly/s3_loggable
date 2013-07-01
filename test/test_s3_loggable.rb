require "test/unit"
require "mocha/setup"
require "s3_loggable"

class TestS3Loggable < Test::Unit::TestCase
  class TestClass; include S3Loggable; def self.initialize(*args); end; end

  def test_credentials_are_unset_raises_an_exception
    Fog.expects(:credentials).returns({})
    ENV.expects(:[]).twice.returns(nil)
    assert_raise(S3Loggable::ConfigurationError) do
      S3Loggable.credentials?
    end
  end

  def test_credentials_is_true_when_fog_is_already_used
    Fog.expects(:credentials).returns({:aws_access_key_id => "ABC",
				       :aws_secret_access_key => "123"})
    assert_equal(S3Loggable.credentials?, true)
  end

  def test_credentials_is_true_when_configuration_is_set
    Fog.expects(:credentials).times(3).returns({})
    config = mock('config')

    S3Loggable.expects(:configuration).twice.returns(config)
    config.expects(:aws_access_key_id).returns('ABC')
    config.expects(:aws_secret_access_key).returns('123')

    assert_equal(S3Loggable.credentials?, true)
  end

  def test_credentials_is_true_when_env_variables_are_set
    Fog.expects(:credentials).times(3).returns({})
    config = mock('config')

    S3Loggable.expects(:configuration).twice.returns(config)
    config.expects(:aws_access_key_id).returns(nil)
    config.expects(:aws_secret_access_key).returns(nil)
    ENV.expects(:[]).with("AWS_ACCESS_KEY_ID").returns("ABC")
    ENV.expects(:[]).with("AWS_SECRET_ACCESS_KEY").returns("123")

    assert_equal(S3Loggable.credentials?, true)
  end

  def test_log_to_s3_instance_method
    logger = mock('logger')
    s3_file = mock('s3_file')
    bucket = 'test-bucket'
    message = {'foo' => 'bar'}
    id = 123
    test_object = TestClass.new

    S3Loggable::Logger.expects(:new).with(bucket).returns(logger)
    logger.expects(:log_to_s3).returns(s3_file)

    assert_equal(test_object.log_to_s3(message, bucket, id), s3_file)
  end
end
