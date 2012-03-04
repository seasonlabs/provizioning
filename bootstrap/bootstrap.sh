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
if [ "$var" == "Ubuntu 11.04 \n \l" ]
then
wget https://raw.github.com/seasonlabs/provizioning/master/bootstrap/natty.sources.list -O sources.list
else
wget https://raw.github.com/seasonlabs/provizioning/master/bootstrap/lucid.sources.list -O sources.list
fi

apt-get update
apt-get -y upgrade

##############################################################################
# Install essential stuff ...
##############################################################################

apt-get update
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

apt-get -y install ruby ruby-dev irb libopenssl-ruby rdoc

cd /tmp
RUBYGEMS="1.8.11"
curl -O http://production.cf.rubygems.org/rubygems/rubygems-$RUBYGEMS.tgz
tar xvzf rubygems-$RUBYGEMS.tgz
ruby rubygems-$RUBYGEMS/setup.rb --no-ri --no-rdoc --no-format-executable

# Cleanup the installation
apt-get -y autoremove

# Install Puppet
gem install puppet --no-ri --no-rdoc