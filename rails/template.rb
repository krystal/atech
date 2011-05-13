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
run "rm README"

## Add a default route
route "root :to => 'pages#home'"

## Add some gems
gem "haml"
gem "will_paginate", "~> 3.0.pre2"
gem "atech"
gem "unicorn"
gem "capistrano"
gem "basic_ssl"
gem "hoptoad_notifier"
gem "atech_cloud"

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
  ActionMailer::Base.smtp_settings = {:address => 'smtp.deliverhq.com', :domain => 'atechmedia.com', :authentication => :cram_md5, :user_name => 'xxxx', :password => 'xxxx'}
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
    = javascript_include_tag 'jquery', 'application'
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
tmp/
config/*.yml
public/stylesheets/*.css
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

file 'public/stylesheets/scss/application.scss', <<-SASS
$monospace-family:'Bitstream Vera Sans Mono', Courier, monospace;
$default-font-family: "Helvetica Neue", Arial, sans-serif;
@import 'reset';
@import 'mixins';

html { font-size:12px; font-family:$default-font-family; background-color:#f2f2f2;}
body { -webkit-font-smoothing: antialiased; margin:10px;}

SASS

file 'public/stylesheets/scss/_reset.scss', <<-RESET
html { color: #000; background: #FFF; }
body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td { margin: 0; padding: 0; }
li { list-style: none; }
h1, h2, h3, h4, h5, h6 { font-size: 100%; font-weight: normal; }
pre, form { font-style: normal; font-weight: normal; }
fieldset { border: 0; }
legend { color: #000; }
input, textarea { margin: 0; padding: 0; font-family: inherit; font-size: inherit; font-weight: inherit; *font-size: 100%; }
p, blockquote { margin: 0; padding: 0; }
th { margin: 0; padding: 0; font-style: normal; font-weight: normal; text-align: left; }
table { border-collapse: collapse; border-spacing: 0; }
img { border: 0; }
address { font-style: normal; font-weight: normal; }
caption { font-style: normal; font-weight: normal; text-align: left; }
cite, dfn, em, strong, var { font-style: normal; font-weight: normal; }
q:before, q:after { content: ''; }
abbr, acronym { border: 0; font-variant: normal; }
sup { vertical-align: text-top; }
sub { vertical-align: text-bottom; }
select { font-family: inherit; font-size: inherit; font-weight: inherit; *font-size: 100%; }

.hidden { display:none !important;}
div.field_with_errors { display:inline !important;}

/* disable safari input highlighting - we don't like this */
input, textarea {outline-style:none;outline-width:0px;}
a:active { outline: none;}

RESET

file 'public/stylesheets/scss/_mixins.scss', <<-MIXINS
@mixin monospace-font() {
  font-family:$monospace-family;
}

@mixin vertical-gradient($start, $stop) { 
  background-color: $stop;
  background-image:-webkit-gradient(linear, left top, left bottom, from($start), to($stop));
  background-image:-moz-linear-gradient(top, $start, $stop);
};

@mixin horizontal-gradient($start, $stop) { 
  background-color: $stop;
  background-image:-webkit-gradient(linear, left top, right top, from($start), to($stop));
  background-image:-moz-linear-gradient(left, $start, $stop);
};

@mixin border-radius($size:10px) {
  border-radius:$size;
  -webkit-border-radius:$size;
  -moz-border-radius:$size;
};

@mixin border-radius-bottom($size:5px) {
  border-bottom-left-radius:$size;
  border-bottom-right-radius:$size;
  -webkit-border-bottom-left-radius:$size;
  -webkit-border-bottom-right-radius:$size;
  -moz-border-radius-bottomleft:$size;
  -moz-border-radius-bottomright:$size;
}

@mixin border-radius-top($size:5px) {
  border-top-left-radius:$size;
  border-top-right-radius:$size;
  -webkit-border-top-left-radius:$size;
  -webkit-border-top-right-radius:$size;
  -moz-border-radius-topleft:$size;
  -moz-border-radius-topright:$size;
}

@mixin border-radius-top-left($size:5px) {
  border-top-left-radius:$size;
  -webkit-border-top-left-radius:$size;
  -moz-border-radius-topleft:$size;
}

@mixin border-radius-top-right($size:5px) {
  border-top-right-radius:$size;
  -webkit-border-top-right-radius:$size;
  -moz-border-radius-topright:$size;
}

@mixin border-radius-left($size:5px) {
  border-top-left-radius:$size;
  border-bottom-left-radius:$size;
  -webkit-border-top-left-radius:$size;
  -webkit-border-bottom-left-radius:$size;
  -moz-border-radius-topleft:$size;
  -moz-border-radius-bottomleft:$size;
}

@mixin border-radius-right($size:5px) {
  border-top-right-radius:$size;
  border-bottom-right-radius:$size;
  -webkit-border-top-right-radius:$size;
  -webkit-border-bottom-right-radius:$size;
  -moz-border-radius-topright:$size;
  -moz-border-radius-bottomright:$size;
}



@mixin box-shadow($h, $v, $b, $colour) {
  -moz-box-shadow: $h $v $b $colour;
  -webkit-box-shadow: $h $v $b $colour;
  box-shadow: $h $v $b $colour;
}

@mixin inset-box-shadow($h, $v, $b, $colour) {
  -moz-box-shadow: inset $h $v $b $colour;
  -webkit-box-shadow: inset $h $v $b $colour;
  box-shadow: inset $h $v $b $colour;
}
MIXINS

## Commit
if File.exist?('.gitignore')
  git :init
  git :add => '.'
  git :commit => "-m 'initial rails skeleton'"
end

file 'Capfile', <<-CAPFILE
require 'atech_cloud/deploy'

## Set the name for the application
set :application, "#{@app_name}"

## Path where the application should be stored
set :repository, "git@codebasehq.com:atechmedia/#{@app_name}/app.git"
set :branch, "master"

## Which rails environment should all processes be executed under
set :environments, "production"

## Define all servers which are 
role :app, "servername.cloud.atechmedia.net", :database_ops => true
CAPFILE

if File.exist?('.gitignore')
  git :init
  git :add => '.'
  git :commit => "-m 'add default capistrano configuration'"
end

## Bundle!
run "bundle install"
