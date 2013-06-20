require 'test/unit'
require 's3_loggable'

class TestS3Loggable < Test::Unit::TestCase
  def test_hi
    assert_equal "Hello", S3Loggable.hi
  end
end
