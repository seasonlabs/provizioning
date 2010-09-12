package :ubuntu_sources do
  transfer File.dirname(__FILE__) + '/../templates/sources.list', '/etc/apt/sources.list', :sudo => true do
    post :install, 'apt-get update'
  end
end