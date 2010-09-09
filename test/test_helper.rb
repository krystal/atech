require 'rubygems'
require 'test/unit'

begin
  require 'leftright'
rescue LoadError
end

if $0 == __FILE__
  Dir["#{File.expand_path('../', __FILE__)}/**/*.rb"].each {|t| require t}
end
