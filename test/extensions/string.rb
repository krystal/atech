require 'test_helper'
require 'atech/extensions/string'

class StringExtensionsTest < Test::Unit::TestCase
  def test_random
    random_string = String.random(10)
    assert random_string.is_a?(String)
    assert random_string.match(/\A[a-z0-9]{10}\z/)
  end
  
  def test_generate_token
    token = String.generate_token
    assert token.is_a?(String)
    assert token.match(/\A[a-f0-9]{8}\-[a-f0-9]{4}\-[a-f0-9]{4}\-[a-f0-9]{4}\-[a-f0-9]{12}\z/)
  end
  
  def test_sha
    assert_equal 'fbb969117edfa916b86dfb67fd11decf1e336df0', 'hello-world'.to_sha1
  end
  
  def test_md5
    assert_equal '2095312189753de6ad47dfe20cbe97ec', 'hello-world'.to_md5
  end
end
