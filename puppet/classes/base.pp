stage { "pre-flight": before => Stage[main] }
class { "base": stage => "pre-flight" }

class base {
  include base::time

  $packagelist = ['git-core', 'vim', 'screen']
  package { $packagelist: 
    ensure => installed
  }

  host { "$hostname.lan" :
    ensure => present,
    host_aliases => $hostname,
    ip => "127.0.0.1"
  }

  host { "localhost" :
    ensure => present,
    ip => "127.0.0.1"
  }

  package {"tcpdump":
    ensure => present
  }

  class time {
    file { "/etc/localtime":
      source => "/usr/share/zoneinfo/Europe/Madrid"
    }

    package { "ntp":
      ensure => present
    }

    service { "ntp":
      ensure => running,
      require => Package["ntp"]
    }

    case  $operatingsystem {
      "CentOS":  {
        file {"/etc/sysconfig/ntpd":
          content => template("base/ntp/ntpd-sysconfig")
        }
      }

      "Debian": {
        # todo
      }
    }
  }

  define set_hostname($hostname) {
    exec { "hostname":
      command => "hostname ${hostname}",
      unless => "test `hostname` = '$hostname'"
    }

    file { "/etc/hostname":
      content => $hostname
    }
  }
}
