# -*- encoding: utf-8 -*-
require File.expand_path('../lib/season/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Victor Castell"]
  gem.email         = ["victor.castell@season.es"]
  gem.summary       = %Q{Server provisioning tool based on Sprinkle}
  gem.description   = %Q{Server provisioning tools, recipes and templates based on Sprinkle}
  gem.homepage      = "http://github.com/seasonlabs/provizioning"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "provizioning"
  gem.require_paths = ["lib"]
  gem.version       = Season::Puppet::VERSION

  gem.add_dependency(%q<capistrano>, [">= 0"])
  gem.add_dependency(%q<capistrano-ext>, [">= 0"])
end
