require 'test_helper'
require 'atech/user_agent'

class UserAgentTest < Test::Unit::TestCase
  
  def test_it_behaves_like_a_string
    agent = Atech::UserAgent.new('Mozilla/5.0 (compatible; MSIE 6.0; Windows NT 5.1)')
    assert "Atech::UserAgent.new('Mozilla/5.0 (compatible; MSIE 6.0; Windows NT 5.1)')", agent
  end
  
  def test_string_inquirer
    agent = Atech::UserAgent.new('Mozilla/5.0 (compatible; MSIE 6.0; Windows NT 5.1)')
    assert agent.name.ie?
    assert agent.os.windows?
    assert !agent.os.mac?
  end
  
  def test_ie6
    agent = Atech::UserAgent.new('Mozilla/5.0 (compatible; MSIE 6.0; Windows NT 5.1)')
    assert_equal 'ie', agent.name
    assert_equal 'windows', agent.os
    assert_equal 6, agent.version
  end
  
  def test_ie7
    agent = Atech::UserAgent.new('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; WOW64; SLCC1; Media Center PC 5.0; .NET CLR 2.0.50727)')
    assert_equal 'ie', agent.name
    assert_equal 'windows', agent.os
    assert_equal 7, agent.version
  end
  
  def test_ie8
    agent = Atech::UserAgent.new('Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; SLCC1; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 1.1.4322)')
    assert_equal 'ie', agent.name
    assert_equal 'windows', agent.os
    assert_equal 8, agent.version
  end
  
  def test_ie9
    agent = Atech::UserAgent.new('Mozilla/5.0 (Windows; U; MSIE 9.0; Windows NT 9.0; en-US)')
    assert_equal 'ie', agent.name
    assert_equal 'windows', agent.os
    assert_equal 9, agent.version
  end
  
  def test_firefox3_windows
    agent = Atech::UserAgent.new('Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2b5) Gecko/20091204 Firefox/3.6b5')
    assert_equal 'firefox', agent.name
    assert_equal 'windows', agent.os
    assert_equal 3, agent.version
  end
  
  def test_firefox4_mac
    agent = Atech::UserAgent.new('Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9b5) Gecko/2008032619 Firefox/4.0b5 	')
    assert_equal 'firefox', agent.name
    assert_equal 'mac', agent.os
    assert_equal 4, agent.version
  end
  
  def test_safari_mac
    agent = Atech::UserAgent.new('Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-us) AppleWebKit/533.17.8 (KHTML, like Gecko) Version/5.0.1 Safari/533.17.8')
    assert_equal 'safari', agent.name
    assert_equal 'mac', agent.os
    assert_equal 5, agent.version
  end

  def test_chrome_mac
    agent = Atech::UserAgent.new('Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; en-US) AppleWebKit/532.9 (KHTML, like Gecko) Chrome/5.0.307.11 Safari/532.9')
    assert_equal 'chrome', agent.name
    assert_equal 'mac', agent.os
    assert_equal 5, agent.version
  end

  def test_chrome_windows
    agent = Atech::UserAgent.new('Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/533.4 (KHTML, like Gecko) Chrome/5.0.375.125 Safari/533.4')
    assert_equal 'chrome', agent.name
    assert_equal 'windows', agent.os
    assert_equal 5, agent.version
  end
    
end