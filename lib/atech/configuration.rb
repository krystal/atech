## This module allows you to create application specific configuration options.
## You can define a block to set your variables or you can simply set them 
## on an instance of the object. The application should define this to begin
## with (`Codebase.settings = Atech::Configuration.new`) or something.

module Atech
  class Configuration
    
    attr_reader :attributes, :callers
    
    def initialize(attributes = Hash.new)
      @attributes = attributes
      @callers = Hash.new
    end
    
    ## Return something helpful for this inspection. We don't need all the attributes.
    ## Use Atech::Configuration#attributes.inspect to look at these.
    def inspect
      Array.new.tap do |a|
        for key, value in attributes
          a << " * #{key.to_s.ljust(30)}: #{value.inspect.ljust(50)} [#{callers[key]}]"
        end
      end.join("\n")
    end
    
    ## Get or set as appropriate. If a requested attribute is not found NoMethodError
    ## will be raised otherwise it will be returned. Requesting an attribute with a 
    ## name suffixed with a question mark (?) will always return a boolean.
    def method_missing(method_name, value = nil)
      method_name = method_name.to_s
      if method_name[-1,1] == '='
        method_name.gsub!(/\=\z/, '')
        callers[method_name] = caller.first
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
