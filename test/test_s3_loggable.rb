require "test/unit"
require "mocha/setup"
require "s3_loggable"

class TestS3Loggable < Test::Unit::TestCase
  def test_credentials?
    Fog.expects(:credentials).returns({})
    assert_raise S3Loggable::ConfigurationError do
      S3Loggable.credentials?
    end

    Fog.expects(:credentials).returns({:aws_access_key_id => "ABC",
				       :aws_secret_access_key => "123"})
    assert_equal S3Loggable.credentials?, true
  end
end
