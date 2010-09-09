def get(url, path, destination = nil)
  destination = path.split('/').last if destination.blank?
  run "curl -L #{url}/#{path} > #{destination}"
end


run "cp config/database.yml config/database.yml.example"

## Remove all the crap rails thinks we need by default
run "rm public/index.html"
run "rm public/javascripts/*.js"
run "rm public/images/rails.png"
run "rm app/views/layouts/application.html.erb"

## Add a default route
route "root :to => 'pages#home'"

## Add some gems
gem "haml"
gem "will_paginate", "~> 3.0.pre2"
gem "atech"

## Require the stnadard atech extensions
file "config/initializers/atech.rb", <<-ATECH
  require 'atech/base'
ATECH

## Add something useful into the seeds file
run "rm db/seeds.rb"
file 'db/seeds.rb', <<-SEEDS
require 'atech/extensions/seeds'
SEEDS

## Add something useful into the default helpers file
run "rm app/helpers/application_helper.rb"
file 'app/helpers/application_helper.rb', <<-HELPER
module ApplicationHelper
  include Atech::Helpers
end
HELPER

## Add some SMTP configuration
file "config/initializers/smtp.rb", <<-SMTP
case Rails.env
when 'production'
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {:address => 'smtp.deliverhq.com', :domain => 'atechmedia.com', :authentication => :md5_cram, :username => 'xxxx', :password => 'xxxx'}
when 'development'
  ActionMailer::Base.delivery_method = :sendmail
end
SMTP

## Add a default layout from haml
file 'app/views/layouts/application.html.haml', <<-HAML
!!!
%html
  %head
    %title== \#{@page_title} - Application 
    = stylesheet_link_tag 'reset', 'application'
    = javascript_include_tag 'jquery'
  %body
    = yield
HAML

## Update the git ignore file to include 
if File.exist?('.gitignore')
  run "rm .gitignore"
  file '.gitignore', <<-IGNORE
.bundle
db/*.sqlite3
log/*.log
tmp/**/*
config/*.yml
IGNORE
end

## Add lib to the autoload path
application_rb = File.read("config/application.rb")
application_rb.gsub!('# config.autoload_paths += %W(#{config.root}/extras)', 'config.autoload_paths += %W(#{config.root}/lib)')
File.open("config/application.rb", 'w') { |f| f.write(application_rb)}

## Add jQuery
inside "public/javascripts" do
  get "http://code.jquery.com", "jquery-1.4.1.min.js", 'jquery.js'
  run "touch application.js"
end

## Add a reset stylesheet
inside "public/stylesheets" do
  get "http://assets.atechmedia.com", "stylesheets/shared/reset.css"
  run "touch application.css"
end

## Commit
if File.exist?('.gitignore')
  git :init
  git :add => '.'
  git :commit => "-m 'initial rails skeleton'"
end

## Bundle!
run "bundle install"
