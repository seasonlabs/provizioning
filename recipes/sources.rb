package :ubuntu_sources do
  transfer '../templates/sources.plist', '/etc/apt/sources.plist', :sudo => true
end