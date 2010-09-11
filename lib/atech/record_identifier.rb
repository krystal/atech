## This module allows you to automatically generate a random unique record
## for a record when it's created. This allows you to hide real IDs from your
## users if you wish/require. If you'd like to use this functionality you can
## include this within your ActiveRecord::Base.
##
##   require 'atech/record_identifier'
##   class ActiveRecord::Base
##     include Atech::RecordIdentifier
##   end
##
## asd

require 'atech/extensions/string'

module Atech
  module RecordIdentifier
    
    def to_param
      self.respond_to?(:identifier) ? identifier : id.to_s
    end
    
    private
    
    def generate_identifier
      return unless self.respond_to?(:identifier)
      self.identifier = String.generate_token
      logger.debug "Generated identifier for '#{self.class}' as '#{self.identifier}'"
    end
    
    def self.included(base)
      base.send(:before_validation, :generate_identifier, :on => :create)
    end
    
  end
end
