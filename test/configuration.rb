require 'test_helper'
require 'atech/configuration'

class ConfigurationTest < Test::Unit::TestCase
  
  def setup
    @configuration = Atech::Configuration.new
  end
  
  def test_block_setup
    @configuration.setup! do |config|
      config.domain = 'codebasehq.com'
      config.ssl_enabled = false
    end
    
    assert_equal 'codebasehq.com', @configuration.domain
    assert_equal false, @configuration.ssl_enabled
  end
  
  def test_manual_setting
    @configuration.domain = 'codebasehq.com'
    assert_equal 'codebasehq.com', @configuration.domain
  end
  
  def test_questions
    @configuration.ssl_enabled = false
    assert_equal false, @configuration.ssl_enabled?
  end
  
  def test_exception
    assert_raise NoMethodError do
      @configuration.blah
    end
  end
  
end
