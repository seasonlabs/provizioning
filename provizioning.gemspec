Gem::Specification.new do |s|
    s.name = 'provizioning'
    s.version = '0.0.1'
    s.summary = 'Server provisioning tool based on Sprinkle'
    s.description = 'Server provisioning tools, recipes and templates based on Sprinkle'
    
    s.authors = ['season', 'Victor Castell']
    s.email = 'victorcoder@gmail.com'
    s.homepage = 'http://github.com/seasonlabs/provizioning'
    s.licenses = 'MIT'

    s.required_ruby_version     = '>= 1.8.7'
    s.required_rubygems_version = ">= 1.3.6"
    
    s.bindir             = 'bin'
    s.executables        = ['provizion']
    s.default_executable = 'provizion'
    s.add_dependency 'sprinkle', '~> 0.3.1'
end