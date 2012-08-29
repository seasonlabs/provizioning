#!/bin/bash

# ruby-stack - Install Ruby and friends.
# Author: Francesc Esplugas <http://francescesplugas.com/>
# License: MIT-LICENSE
#
# DON'T CHANGE THIS FILE UNLESS YOU KNOW WHAT YOU'RE DOING!

##############################################################################
# Abort on any error.
##############################################################################

set -e

##############################################################################
# Update and upgrade the system.
##############################################################################

cd /etc/apt

# Sources depending on Ubuntu Version
var=`cat /etc/issue`

if [ "$var" == "Ubuntu 10.04 \n \l" ]
then
wget https://raw.github.com/seasonlabs/provizioning/master/bootstrap/lucid.sources.list -O sources.list
fi

if [ "$var" == "Ubuntu 11.04 \n \l" ]
then
wget https://raw.github.com/seasonlabs/provizioning/master/bootstrap/natty.sources.list -O sources.list
fi

if [ "$var" == "Ubuntu 12.04 \n \l" ]
then
wget https://raw.github.com/seasonlabs/provizioning/master/bootstrap/precise.sources.list -O sources.list
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y upgrade

##############################################################################
# Install essential stuff ...
##############################################################################

apt-get -y install build-essential
apt-get -y install git-core
apt-get -y install vim
apt-get -y install curl

##############################################################################
# Extra stuff to make things work ...
##############################################################################

echo 'export LANG=en_US.UTF-8' > /etc/default/locale
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales

##############################################################################
# Install Ruby
##############################################################################

if [ "$var" == "Ubuntu 10.04 \n \l" ]
then
	apt-get -y install ruby ruby-dev irb libopenssl-ruby
else
	apt-get -y install ruby1.9.1 ruby1.9.1-dev libruby1.9.1
fi

cd /tmp
RUBYGEMS="1.8.24"
curl -O http://production.cf.rubygems.org/rubygems/rubygems-$RUBYGEMS.tgz
tar xvzf rubygems-$RUBYGEMS.tgz
ruby rubygems-$RUBYGEMS/setup.rb --no-ri --no-rdoc --no-format-executable

# Cleanup the installation
apt-get -y autoremove

# Install Puppet
gem install puppet --no-ri --no-rdoc