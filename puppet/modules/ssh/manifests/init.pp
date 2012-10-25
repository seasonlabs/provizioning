# Manage a bit of ssh properties
class ssh {
	define append_ssh_key_to_root($key) {
    append_ssh_key_to_user {$name:
      user => "root", 
      key => $key,
    }
  }

  define append_ssh_key_to_user($user, $key, $key_type="ssh-rsa") {
    ssh_authorized_key {$name:
      ensure => present,
      user => $user,
      key => $key,
      name => $name,
      type => $key_type,
    }
  }
}