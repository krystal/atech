require 'test_helper'
require 'atech/network_restrictions'

class NetworkRestrictionsText < Test::Unit::TestCase
  
  def test_setting_networks
    new_networks = ['123.123.123.123/32']
    Atech::NetworkRestrictions.networks = new_networks
    assert_equal new_networks, Atech::NetworkRestrictions.networks
  end
  
  def test_reading_default_network_list
    assert Atech::NetworkRestrictions.networks.is_a?(Array)
  end
  
  def test_returning_an_approved_ip
    assert_equal '127.0.0.1/32', Atech::NetworkRestrictions.approved_ip('127.0.0.1')
  end
  
  def test_passing_invalid_ip_addresses_returns_false
    assert_equal false, Atech::NetworkRestrictions.approved_ip('blahblahblah')
  end
  
  def test_approved_ip_question_method
    assert_equal true, Atech::NetworkRestrictions.approved_ip?('127.0.0.1')
    assert_equal false, Atech::NetworkRestrictions.approved_ip?('12.13.14.15')
  end
  
  def test_route_constraint
    assert Atech::NetworkRestrictions::RouteConstraint.matches?(FakeRequest.new('127.0.0.1'))
    assert !Atech::NetworkRestrictions::RouteConstraint.matches?(FakeRequest.new('13.14.15.16'))
  end
end

## This class is used for faking a request used for route contraints.
class FakeRequest
  attr_reader :ip

  def initialize(ip)
    @ip = ip
  end
end
