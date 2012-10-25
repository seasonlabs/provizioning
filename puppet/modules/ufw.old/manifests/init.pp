class ufw {
  package{ "ufw":
    ensure => installed,
  }
  
  exec { "Set default rules":
    user => "root",
    path => "/usr/bin:/usr/sbin:/bin",
    command => "ufw allow to 0.0.0.0/0 port 80 && ufw allow to 0.0.0.0/0 port 443 && ufw allow to 0.0.0.0/0 port 3000 && ufw allow 10000:10020/tcp && ufw allow to 0.0.0.0/0 port 22",
    require => Package["ufw"],
  }
}