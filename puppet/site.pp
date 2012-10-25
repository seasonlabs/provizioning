Exec {
  path => [
    '/usr/local/sbin',
    '/usr/local/bin',
    '/opt/local/bin',
    '/usr/bin', 
    '/usr/sbin', 
    '/bin',
    '/sbin'],
  logoutput => true,
}

import "classes/*"
include base, gemrc, logrotate

import "roles/*"