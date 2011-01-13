## This file should be required in your 'db/seeds.rb' file if you'd like some
## nice reporting whenever you run your database seed.
##
##    require 'atech/extensions/seeds'

module ActiveRecord
  class Base
    def save(options = {})
      return super(options) unless Rails.env.development?
      
      unless super(options)
        puts "\e[31m#{self.inspect}"
        puts "#{self.errors.inspect}\e[0m"
        Process.exit(1)
      else
        puts "\e[32mcreated\e[0m #{self.class.name} ##{self.id}"
      end
    end
    
    def destroy(*args)
      puts "\e[31mdestroyed\e[0m #{self.class.name} ##{self.id}"
      super(*args)
    end
    
    def self.seedable?
      actual_count = self.count.to_i
      return (actual_count == 0) unless Rails.env.development?
      if actual_count == 0
        puts "\e[33;44madding #{self.name.to_s} objects\e[0m"
        true
      else
        puts "\e[33mskipping #{self.name.to_s} (#{actual_count} objects already exist)\e[0m"
        false
      end
    end
  end
end
