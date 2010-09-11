## Include this file in your ApplicationHelper to add some standard and useful
## HTML helpers for your Rails applications.
##
##    module ApplicationHelper
##      include Atech::Helpers
##      
##      ... your own helpers..
##
##    end

module Atech
  module Helpers

    ## Flash all flash messages which have been stored.
    def display_flash
      flashes = flash.collect do |key,msg|
        content_tag :div, content_tag(:p, h(msg)), :id => "flash-#{key}"
      end.join.html_safe
    end
    
    ## Insert an image tag for an icon from the 'public/images/icons' folder. If passed a symbol
    ## it will automatically add '.png' to the end of the name, otherwise you need to pass the 
    ## full image file name.
    def icon_tag(icon, text = '')
      extension = (icon.is_a?(Symbol) ? ".png" : '')
      image_tag "icons/#{icon.to_s}#{extension}", :alt => text, :title => text, :class => "icon #{icon}"
    end
    
    ## Alias 'c' to 'number_to_currency'
    def c(*opts)
      number_to_currency(*opts)
    end
    
    ## Insert a gravatar for a specified e-mail address.
    def gravatar(email, options = {})
      options[:size]    ||= 35
      options[:default] ||= 'identicon'
      options[:rating]  ||= 'PG'
      options[:class]   ||= 'gravatar'
      options[:secure]  ||= request.ssl?
      
      host = (options[:secure] ? 'https://secure.gravatar.com' : 'http://gravatar.com')
      path = "/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(email)}&rating=#{options[:rating]}&size=#{options[:size]}&d=#{options[:default]}"
      
      image_tag([host,path].join, :class => options[:class], :width => options[:size], :height => options[:size])
    end
    
    ## Return a set of three classes allowing you to determine the user agent of the clients computer.
    ## This method can be called as part of the <html> or <body> class. It will return the
    ## operating system, the browser's name and the version number.
    def user_agent_classes
      if defined?(Atech::UserAgent) && request.user_agent.is_a?(Atech::UserAgent)
        "#{request.user_agent.os} #{request.user_agent.name} v#{request.user_agent.version}"
      end
    end
    
    ## Sets the page title to be passed value or returns the current value if it's empty
    def page_title(text = nil)
      text ? (@page_title = text) : @page_title
    end
    
  end
end
