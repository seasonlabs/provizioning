package :ubuntu_sources do
  transfer File.dirname(__FILE__) + '../templates/sources.plist', '/etc/apt/sources.plist', :sudo => true
end