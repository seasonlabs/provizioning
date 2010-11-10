package :chef_client do
  description 'Chef client bootstrap'
  gem 'chef'
  requires :ruby

  verify do
    has_gem 'chef'
  end
end

#ruby ruby-dev libopenssl-ruby rdoc ri irb build-essential wget ssl-cert
