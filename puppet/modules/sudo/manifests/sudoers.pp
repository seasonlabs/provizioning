class sudo::sudoers {

  file { "/tmp/sudoers":
    mode => 440,
    source => "puppet:///modules/sudo/sudoers",
    notify => Exec["check-sudoers"],
  }

  exec { "check-sudoers":
    command => "/usr/sbin/visudo -cf /tmp/sudoers && cp /tmp/sudoers /etc/sudoers",
    refreshonly => true,
  }

}