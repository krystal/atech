require 'active_support/string_inquirer'

if defined?(ActionController::Request)
  class ActionController::Request
    def user_agent
      Atech::UserAgent.new(env['HTTP_USER_AGENT'])
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
      when /Chrome\/(\d+)/ then [:chrome, $1.to_i]
      when /Version\/(\d+).*Safari\//i then [:safari, $1.to_i]
      else [:unknown, 0]
      end
    end
    
  end
end
