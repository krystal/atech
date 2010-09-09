module Atech
  module NetworkRestrictions
    
    class << self
      attr_accessor :networks
      
      def networks
        @networks ||= ['127.0.0.1/32', '109.224.145.104/29', '83.170.74.114/32', '10.0.1.0/24']
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
      end
    end
    
    class RouteConstraint
      def self.matches?(request)
        Atech::NetworkRestrictions.approved_ip?(request.ip)
      end
    end
    
  end
end
