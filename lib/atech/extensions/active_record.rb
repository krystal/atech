module ActiveRecord
  class Base
    
    ## Add a shortcut for adding a dependency for a model
    def self.concerned_with(*concerns)
      concerns.each do |concern|
        require_dependency "#{name.underscore}/#{concern}"
      end
    end
  end
end
