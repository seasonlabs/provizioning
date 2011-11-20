class rvm::ruby($ruby_version, $rvm_prefix) {
    $binpath = "${rvm_prefix}bin/"
    
    exec { 
        "rvm-install-ruby":
            command => "${binpath}rvm install ${ruby_version}",
            creates => "${rvm_prefix}rvm/rubies/${ruby_version}",
            logoutput => 'on_failure',
            timeout => "-1",
            require => [Class["rvm::system"], Exec["system-rvm"]];
    }
}

class rvm::passenger($ruby_version, $version, $rvm_prefix) {
    $gempath = "${rvm_prefix}rvm/gems/${ruby_version}/gems"
    $binpath = "${rvm_prefix}rvm/rubies/${ruby_version}/bin"
    
    exec {
        "passenger-gem":
            command => "${rvm_prefix}rvm/rubies/${ruby_version}/bin/gem install passenger --no-ri --no-rdoc",
            creates => "${binpath}/passenger",
            require => Exec["rvm-install-ruby"];
    }
}

class rvm::passenger::apache(
    $ruby_version = 'ruby-1.9.2-p290',
    $version = '3.0.8',
    $rvm_prefix = '/usr/local/',
    $mininstances = '1',
    $maxpoolsize = '6',
    $poolidletime = '300',
    $maxinstancesperapp = '0',
    $spawnmethod = 'smart-lv2'
) {

    # TODO: How can we get the gempath automatically using the ruby version
    # Can we read the output of a command into a variable?
    # e.g. $gempath = `usr/local/bin/rvm ${ruby_version} exec rvm gemdir`
    $gempath = "${rvm_prefix}rvm/gems/${ruby_version}/gems"
    $binpath = $rvm_prefix ? {
        '/usr/local/' => '/usr/local/bin/',
        default => "${rvm_prefix}rvm/bin/"
    }

    # TODO: How to inherit this from above?
    class { 'rvm::ruby': ruby_version => $ruby_version, rvm_prefix => $rvm_prefix }
    class { 'rvm::passenger': ruby_version => $ruby_version, version => $version, rvm_prefix => $rvm_prefix }
    include apache    

    # Dependencies
    if ! defined(Package['build-essential'])      { package { build-essential:      ensure => installed } }
    if ! defined(Package['apache2-prefork-dev'])  { package { apache2-prefork-dev:  ensure => installed } }
    if ! defined(Package['libapr1-dev'])          { package { libapr1-dev:          ensure => installed, alias => 'libapr-dev' } }
    if ! defined(Package['libaprutil1-dev'])      { package { libaprutil1-dev:      ensure => installed, alias => 'libaprutil-dev' } }
    if ! defined(Package['libcurl4-openssl-dev']) { package { libcurl4-openssl-dev: ensure => installed } }

    exec {
        'passenger-install-apache2-module':
            command => "${binpath}rvm ${ruby_version} exec passenger-install-apache2-module -a",
            creates => "${gempath}/passenger-${version}/ext/apache2/mod_passenger.so",
            logoutput => 'on_failure',
            require => [
                Class['rvm::system'],
                Exec['system-rvm'],
                Exec['rvm-install-ruby'],
                Exec['passenger-gem'],
                Package[
                    'apache2',
                    'build-essential',
                    'apache2-prefork-dev',
                    'libapr-dev',
                    'libaprutil-dev',
                    'libcurl4-openssl-dev'
                ]
            ];
    }

    file {
        '/etc/apache2/mods-available/passenger.load':
            content => "LoadModule passenger_module ${gempath}/passenger-${version}/ext/apache2/mod_passenger.so",
            ensure => file,
            require => Exec['passenger-install-apache2-module'];

        '/etc/apache2/mods-available/passenger.conf':
            content => template('rvm/passenger-apache.conf.erb'),
            ensure => file,
            require => Exec['passenger-install-apache2-module'];

        '/etc/apache2/mods-enabled/passenger.load':
            ensure => 'link',
            target => '../mods-available/passenger.load',
            require => File['/etc/apache2/mods-available/passenger.load'];

        '/etc/apache2/mods-enabled/passenger.conf':
            ensure => 'link',
            target => '../mods-available/passenger.conf',
            require => File['/etc/apache2/mods-available/passenger.conf'];
    }

    # Add Apache restart hooks
    File['/etc/apache2/mods-available/passenger.load'] ~> Service['apache']
    File['/etc/apache2/mods-available/passenger.conf'] ~> Service['apache']
    File['/etc/apache2/mods-enabled/passenger.load']   ~> Service['apache']
    File['/etc/apache2/mods-enabled/passenger.conf']   ~> Service['apache']
}

class ruby::passenger::apache::disable {

    file {
        '/etc/apache2/mods-enabled/passenger.load':
            ensure => 'absent';
        '/etc/apache2/mods-enabled/passenger.conf':
            ensure => 'absent';
    }

    # Add Apache restart hooks
    if defined(Service['apache']) { File['/etc/apache2/mods-enabled/passenger.load']   ~> Service['apache'] }
    if defined(Service['apache']) { File['/etc/apache2/mods-enabled/passenger.conf']   ~> Service['apache'] }
}

class rvm::passenger::nginx(
    $ruby_version = 'ruby-1.9.2-p290',
    $version = '3.0.8',
    $rvm_prefix = '/usr/local/',
    $mininstances = '1',
    $maxpoolsize = '6',
    $poolidletime = '300',
    $maxinstancesperapp = '0',
    $spawnmethod = 'smart-lv2'
) {

    # TODO: How can we get the gempath automatically using the ruby version
    # Can we read the output of a command into a variable?
    # e.g. $gempath = `usr/local/bin/rvm ${ruby_version} exec rvm gemdir`
    $gempath = "${rvm_prefix}rvm/gems/${ruby_version}/gems"
    $binpath = $rvm_prefix ? {
        '/usr/local/' => '/usr/local/bin/',
        default => "${rvm_prefix}rvm/bin/"
    }

    # TODO: How to inherit this from above?
    class { 'rvm::ruby': ruby_version => $ruby_version, rvm_prefix => $rvm_prefix }
    class { 'rvm::passenger': ruby_version => $ruby_version, version => $version, rvm_prefix => $rvm_prefix }   

    # Dependencies
    if ! defined(Package['build-essential'])      { package { build-essential:      ensure => installed } }
    if ! defined(Package['libcurl4-openssl-dev']) { package { libcurl4-openssl-dev: ensure => installed } }

    exec {
        'passenger-install-nginx-module':
            command => "${binpath}rvm ${ruby_version} exec passenger-install-nginx-module --auto --auto-download",
            creates => "${gempath}/passenger-${version}/ext/nginx/mod_passenger.so",
            logoutput => 'on_failure',
            require => [
                Class['rvm::system'],
                Exec['system-rvm'],
                Exec['rvm-install-ruby'],
                Exec['passenger-gem'],
                Package[
                    'build-essential',
                    'libcurl4-openssl-dev'
                ]
            ];
    }
}
