#
# Class: imagemagick
#
# Include it to install and imagemagick
# It defines package.
#
# Usage:
# include imagemagick
#

class imagemagick {
  package{ "imagemagick":
    ensure => installed,
  }
  
  package{ "libmagickwand-dev":
    ensure => installed,
  }
}