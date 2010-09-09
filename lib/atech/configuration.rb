## This module allows you to create application specific configuration options.
## You can define a block to set your variables or you can simply set them 
## on an instance of the object. The application should define this to begin
## with (`Codebase.settings = Atech::Configuration.new`) or something.

module Atech
  class Configuration
    
    attr_reader :attributes
    
    def initialize(attributes = Hash.new)
      @attributes = attributes
    end
    
    def setup!(&block)
      block.call(self)
    end
    
    def method_missing(method_name, value = nil)
      method_name = method_name.to_s
      if method_name[-1,1] == '='
        method_name.gsub!(/\=\z/, '')
        attributes[method_name] = value
      else
        question = false
        if method_name =~ /\?\z/
          method_name.gsub!(/\?\z/, '')
          question = true
        end

        if attributes.keys.include?(method_name)
          if question
            !!attributes[method_name]
          else
            attributes[method_name]
          end
        else
          raise NoMethodError, "undefined configurtion attribute `#{method_name}' for #{self}"
        end
      end
    end
  end
end
