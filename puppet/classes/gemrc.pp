# Ruby should already be installed, so this class just adds to the ruby environment]
# by adding bundler, etc.

class gemrc {
  file { "/root/.gemrc":
    content => template("gemrc/gemrc"),
    owner => root,
    group => root
  }
}