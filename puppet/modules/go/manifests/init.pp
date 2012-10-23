class go {
	exec {"get-gophers-apt-key":
      command => "apt-key adv --keyserver keyserver.ubuntu.com --recv 9AD198E9 ",
      unless => "apt-key list | grep 9AD198E9 ",
    }
        
    file {"/etc/apt/sources.list.d/go.list":
      ensure => present,
      owner => root,
      group => root,
      content => "deb http://ppa.launchpad.net/gophers/go/ubuntu ${lsbdistcodename} main",
      require => Exec["get-gophers-apt-key"],
    }

    exec {"update apt to find golang":
      command => "/usr/bin/apt-get -y update",
      require => File["/etc/apt/sources.list.d/go.list"],
      subscribe => File["/etc/apt/sources.list.d/go.list"],
      refreshonly => true,
    }

    package {"golang":
      ensure => latest,
      require =>  Exec["update apt to find golang"],
    }
}