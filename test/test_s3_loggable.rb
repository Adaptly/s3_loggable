require "test/unit"
require "mocha/setup"
require "s3_loggable"

class TestS3Loggable < Test::Unit::TestCase

  def test_credentials_is_false?
    Fog.expects(:credentials).returns({})
    ENV.expects(:[]).with("AWS_ACCESS_KEY_ID").returns(nil)
    assert_raise(S3Loggable::ConfigurationError) do
      S3Loggable.credentials?
    end
  end

  def test_credentials_is_true?
    Fog.expects(:credentials).returns({:aws_access_key_id => "ABC",
				       :aws_secret_access_key => "123"})
    assert_equal(S3Loggable.credentials?, true)
  end

end
