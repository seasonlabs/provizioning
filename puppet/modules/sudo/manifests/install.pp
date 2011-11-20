class sudo::install {
  package{ "sudo":
    ensure => installed,
  }
}
