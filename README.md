Server provisioning tool
========================

Intro
-----

Provizioning is the tool that Season use internally to setup new machines it uses Capistrano for bootstrapping the server and uploading the recipes, then use puppet for configuration and fine tunning.

Usage
-----

Include provizioning in your gem file:

	gem 'provizioning'

Setup a directory for capistrano use:

	capify .

Configure deploy.rb :user var for deployment and provisioning or use :puppet_user for provisioning:

	set :puppet_user, 'root'

Use capistrano tasks to provision the server:

	bundle exec cap puppet:bootstrap
	bundle exec cap puppet:apply

Based on https://github.com/freerange/freerange-puppet