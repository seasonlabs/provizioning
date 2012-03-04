Exec {
  path => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin"
}

import "classes/*"
include base, gemrc, logrotate, ufw

import "roles/*"