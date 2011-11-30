# Class: users
#
# Manages local users and external authentication methods 
#
# Usage:
# include users
#
class users {
  define user_homedir($fullname) {
    user { "$name":
      comment => "$fullname",
      home => "/home/$name"
    }

    exec { "$name homedir":
      command => "cp -R /etc/skel /home/$name; chown -R $name /home/$name",
      path => "/bin:/usr/sbin",
      creates => "/home/$name",
      require => User[$name],
    }
  }
}