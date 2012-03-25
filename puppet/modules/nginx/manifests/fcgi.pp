# Class: nginx::fcgi
#
# Manage nginx fcgi configuration.
# Provide nginx::fcgi::site 
#
# Templates :
#	* nginx/includes/fastcgi_params.erb
#
class nginx::fcgi inherits nginx {

	nginx::site_include{"fastcgi_params": 
		content => template("nginx/includes/fastcgi_params.erb"),
	}

	# Define: nginx::fcgi::site
	#
	# Create a fcgi site config from template using parameters.
	# You can use my php5-fpm class to manage fastcgi servers.
	#
	# Parameters :
	# 	* ensure: typically set to "present" or "absent". Defaults to "present"
	# 	* root: document root (Required)
	#	* fastcgi_pass : port or socket on which the FastCGI-server is listening (Required)
	#	* server_name : server_name directive (could be an array)
	#	* listen : address/port the server listen to. Defaults to 80. Auto enable ssl if 443
	#	* access_log : custom acces logs. Defaults to /var/log/nginx/$name_access.log
	#	* include : custom include for the site (could be an array). Include files must exists 
	#	   to avoid nginx reload errors. Use with nginx::site_include  
	#	* ssl_certificate : ssl_certificate path. If empty auto-generating ssl cert
	#	* ssl_certificate_key : ssl_certificate_key path. If empty auto-generating ssl cert key
	#   See http://wiki.nginx.org for details.
	#
	# Templates :
	#	* nginx/fcgi_site.erb
	#	* nginx/fcgi_drupal_site.erb
	#
	# Sample Usage :
	#         nginx::fcgi::site {"default":
	#                 root            => "/var/www/nginx-default",
	#                 fastcgi_pass    => "127.0.0.1:9000",
	#                 server_name     => ["localhost", "$hostname", "$fqdn"],
	#          }
	#
	#         nginx::fcgi::site {"default-ssl":
	#                 listen          => "443",
	#                 root            => "/var/www/nginx-default",
	#                 fastcgi_pass    => "127.0.0.1:9000",
	#                 server_name     => "$fqdn",
	#          }
  #          
  #          nginx::fcgi::drupal_site {"default":
	#                 root            => "/var/www/nginx-default",
	#                 fastcgi_pass    => "127.0.0.1:9000",
	#                 server_name     => ["localhost", "$hostname", "$fqdn"],
	#          }
	#

	define site($ensure = 'present', $index = 'index.php', $root, $fastcgi_pass, $template = "nginx/fcgi_site.erb", $include = '', $listen = '80', $server_name = '', $access_log = '', $error_log = '', $ssl_certificate = '', $ssl_certificate_key = '', $ssl_session_timeout = '5m') { 

		$real_server_name = $server_name ? { 
			'' => "${name}",
      default => $server_name,
    }

		$real_access_log = $access_log ? { 
			'' => "/var/log/nginx/${name}_access.log",
      default => $access_log,
    }

    $real_error_log = $error_log ? { 
		  '' => "/var/log/nginx/${name}_error.log",
      default => $error_log,
    }

    $packagelist = ['php5-cgi', 'psmisc', 'spawn-fcgi']
    package { $packagelist: 
      ensure => installed,
    }

    file {"/var/run/php-fastcgi":
      ensure => directory,
      owner => 'www-data', group => 'www-data'
    }

    file {"/usr/bin/php-fastcgi":
      source => 'puppet:///modules/nginx/php-fastcgi',
      owner => 'root', group => 'root', mode => '0777',
      ensure => present,
    }

    file {"/etc/init.d/init-php-fastcgi":
      source => 'puppet:///modules/nginx/init-php-fastcgi',
      owner => 'root', group => 'root', mode => '0777',
      ensure => present,
    }

    service {"init-php-fastcgi":
      ensure => running,
      subscribe => File['/usr/bin/php-fastcgi'],
      enable => true,
      hasstatus => false,
      pattern => '/usr/bin/php5-cgi',
      require => [
        File['/usr/bin/php-fastcgi'], 
        File['/etc/init.d/init-php-fastcgi'], 
        File['/var/run/php-fastcgi']
      ],
    }
    
		#Autogenerating ssl certs
		if $listen == '443' and  $ensure == 'present' and ( $ssl_certificate == '' or $ssl_certificate_key == '') {
			exec {"generate-${name}-certs":
				command => "/usr/bin/openssl req -new -inform PEM -x509 -nodes -days 999 -subj '/C=ZZ/ST=AutoSign/O=AutoSign/localityName=AutoSign/commonName=${real_server_name}/organizationalUnitName=AutoSign/emailAddress=AutoSign/' -newkey rsa:2048 -out /etc/nginx/ssl/${name}.pem -keyout /etc/nginx/ssl/${name}.key",
				unless	=> "/usr/bin/test -f /etc/nginx/ssl/${name}.pem",
				require	=> File["/etc/nginx/ssl"],
				notify	=> Exec["reload-nginx"],
			}
		}

		$real_ssl_certificate = $ssl_certificate ? { 
			'' => "/etc/nginx/ssl/${name}.pem",
      default => $ssl_certificate,
    }
		
    $real_ssl_certificate_key = $ssl_certificate_key ? { 
			'' => "/etc/nginx/ssl/${name}.key",
      default => $ssl_certificate_key,
    }

		nginx::site {"${name}":
			ensure	=> $ensure,
			content	=> template($template),
		}
		
	}
  
  define drupal_site($ensure = 'present', $index = 'index.php', $root, $fastcgi_pass, $include = '', $listen = '80', $server_name = '', $access_log = '', $error_log = '', $ssl_certificate = '', $ssl_certificate_key = '', $ssl_session_timeout = '5m') {
    nginx::fcgi::site {"${name}":
      ensure              => $ensure, 
      index               => $index, 
      root                => $root, 
      fastcgi_pass        => $fastcgi_pass, 
      template            => "nginx/fcgi_drupal_site.erb", 
      include             => $include, 
      listen              => $listen, 
      server_name         => $server_name, 
      access_log          => $access_log, 
      error_log           => $error_log, 
      ssl_certificate     => $ssl_certificate, 
      ssl_certificate_key => $ssl_certificate_key, 
      ssl_session_timeout => $ssl_session_timeout, 
    }
  }
}
