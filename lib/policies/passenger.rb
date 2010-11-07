# Require our stack
require "provizioning"

policy :passenger_stack, :roles => :app do
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
      recipes 'config/deploy'
    end
    recipes 'config/server/config.rb'
  end
 
  # source based package installer defaults
  source do
    prefix   '/usr/local'
    archives '/usr/local/sources'
    builds   '/usr/local/build'
  end
end