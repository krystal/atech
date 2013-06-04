## Implements support for detecting whether an IP address belongs to a pre-defined
## set of networks specified in CIDR notation. By default, it uses the standard
## aTech Media IP addresses + localhost. The range of IPs can be changed by
## changing `Atech::NetworkRestrictions.networks` to an array containing strings
## of other networks.

## You can use the included Atech::NetworkRestrictions::RouteConstraint in your
## routing files to restrict routes. For example:
##
##    constraints Atech::NetworkRestrictions::RouteConstraint do
##       namespace :admin do
##         resources :accounts
##         resources :tickets
##       end
##    end
##
## You can also use this method to query IP addresses whenever required using
## `Atech::NetworkRestrictions.approved_ip?('123.123.123.123')`.

require 'ipaddr'

module Atech
  module NetworkRestrictions
    
    class << self
      attr_accessor :networks
      
      def networks
        @networks ||= [
          '127.0.0.1/32',         # localhost
          '185.22.208.0/25',      # infra
          '109.104.109.0/26',     # bournemouth network
          '10.17.0.0/24',         # vpn
          '10.0.2.0/24',          # office
          '2a00:67a0:a:1::/64',   # infra ipv6
          '2a00:67a0:a:5::/64',   # vpn ipv6
          '2a00:67a0:a:6::/64',   # office ipv6
          '2001:9d8:2005:1::/64'  # bournemouth ipv6
        ]
      end
      
      def approved_ip?(requested_ip)
        !!approved_ip(requested_ip)
      end
      
      def approved_ip(requested_ip)
        self.networks.each do |i|
          if IPAddr.new(i).include?(requested_ip)
            return i
          end
        end
        return false
      rescue ArgumentError => e
        if e.message == 'invalid address'
          return false
        else
          raise
        end
      end
    end
    
    class RouteConstraint
      def self.matches?(request)
        Atech::NetworkRestrictions.approved_ip?(request.ip)
      end
    end
    
  end
end
