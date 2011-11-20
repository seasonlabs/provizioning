class passenger($ruby_version = 'ruby-1.9.3-p0') {
  exec { "passenger-gem":
    command => "/usr/local/bin/gem install passenger --no-ri --no-rdoc",
    creates => "/usr/local/stow/${ruby_version}/bin",
    require => [Package["stow"], Exec["ruby-stow"]];
  }
  
  exec { "restow": 
    command => "/usr/bin/stow -d /usr/local/stow ${ruby_version}",
    require => Exec["passenger-gem"];
  }
}