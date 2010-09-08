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
    
  end
end
