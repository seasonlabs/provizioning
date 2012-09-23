# Copyright (c) 2008, Luke Kanies, luke@madstop.com
# 
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

class postgres {
  include "postgres::$operatingsystem"
  $require = File['/etc/apt/sources.list.d/postgres.list']

	package { [postgresql]: 
    ensure => installed,
    name => 'postgresql-9.2'
  }
	package { [libpq-dev]: ensure => installed }

    service { "postgresql":
      ensure => running,
      enable => true,
      hasstatus => true,
      subscribe => [Package[postgresql]],
      require => $require,
    }

    class ubuntu {
    	include apt
		
  		exec {"get-postgres-apt-key":
        command => "apt-key adv --keyserver keyserver.ubuntu.com --recv 8683D8A2"
      }

  		file {"/etc/apt/sources.list.d/postgres.list":
  			ensure => present,
  			owner => root,
  			group => root,
  			content => "deb http://ppa.launchpad.net/pitti/postgresql/ubuntu ${lsbdistcodename} main",
  			require => Exec["get-postgres-apt-key"],
  		}

  		exec {"update apt to find postgres":
  			command => '/usr/bin/apt-get -y update',
  			require => File['/etc/apt/sources.list.d/postgres.list'],
  		}
    }
}
