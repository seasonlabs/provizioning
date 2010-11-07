# Require our stack
require "provizioning"

policy :passenger_stack, :roles => :app do
  requires :ubuntu_sources
  requires :build_essential
  requires :vim
  requires :git
  requires :curl
  
  requires :webserver        # Apache
  requires :database         # MySQL, SQLite
  
  requires :scm              # Git, SVN
  requires :ruby             # Ruby Enterprise
  requires :appserver        # passenger
  requires :sudo_user        # special rails user with sudo rights
  requires :imagemagick      # image magick
end

deployment do
  # mechanism for deployment
  delivery :capistrano do
    begin
      recipes 'Capfile'
    rescue LoadError
      recipes 'deploy'
    end
  end
 
  # source based package installer defaults
  source do
    prefix   '/usr/local'
    archives '/usr/local/sources'
    builds   '/usr/local/build'
  end
end

# Depend on a specific version of sprinkle 
begin
  gem 'sprinkle', ">= 0.3.1" 
rescue Gem::LoadError
  puts "sprinkle 0.3.1 required.\n Run: `sudo gem install sprinkle`"
  exit
end