class ruby($version = 'ruby-1.9.3-p0') {
  file {"ruby-stow-boot":
    ensure => 'present',
    path => '/root/install-ruby-stow',
    owner => 'root', group => 'root', mode => '0774',
    source => 'puppet:///modules/ruby/install-ruby-stow';
  }

  exec { "ruby-stow":
    command => "/root/install-ruby-stow",
    creates => "/usr/local/stow/${version}",
    timeout => "-1",
    require => [Package["stow"], File["ruby-stow-boot"]];
  }
  
  if ! defined(Package['build-essential'])      { package { 'build-essential': ensure => installed } }
  if ! defined(Package['libcurl4-openssl-dev']) { package { 'libcurl4-openssl-dev': ensure => installed } }
}