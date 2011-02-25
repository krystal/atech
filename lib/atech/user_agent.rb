## This module provides additional functionality to the ActionController::Request#user_agent
## method (request.user_agent to a layman). It add options for interogating the 
## browser's name, operating system and version. For example.
## 
##    request.user_agent                #=> [raw user agent string]
##    request.user_agent.os             #=> 'mac'
##    request.user_agent.name           #=> 'safari'
##    request.user_agent.version        #=> 5
##    request.user_agent.os.windows?    #=> false
##    request.user_agent.os.mac?        #=> true
##    reuqest.user_agent.name.safari?   #=> false
##
## At the moment it supoprts IE, Firefox, Safari & Chrome.

require 'active_support/string_inquirer'

if defined?(ActionController::Request)
  class ActionController::Request
    def user_agent
      env['HTTP_USER_AGENT'].is_a?(String) ? Atech::UserAgent.new(env['HTTP_USER_AGENT']) : nil
    end
  end
end

module Atech
  class UserAgent < String
    
    def os
      ActiveSupport::StringInquirer.new(case self
      when /(windows)|(win(\d{2}))/i then :windows
      when /linux/i then :linux
      when /macintosh/i then :mac
      when /(iPhone)|(iPod)/ then :iphone
      when /iPad/ then :ipad
      else :unknown
      end.to_s)
    end
    
    def name
      ActiveSupport::StringInquirer.new(name_and_version.first.to_s)
    end
        
    def version
      name_and_version.last
    end
    
    private
    
    def name_and_version
      @name_and_version ||= case self
      when /MSIE (\d+)/i then [:ie, $1.to_i]
      when /Firefox\/(\d+)/ then [:firefox, $1.to_i]
      when /Version\/(\d+).*Mobile\/.+Safari/ then [:mobile_safari, $1.to_i]
      when /Chrome\/(\d+)/ then [:chrome, $1.to_i]
      when /Version\/(\d+).*Safari\//i then [:safari, $1.to_i]
      else [:unknown, 0]
      end
    end
    
  end
end
