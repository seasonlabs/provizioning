class webmin {
    $base = "webmin_1.580_all.deb"
    $url = "http://prdownloads.sourceforge.net/webadmin/"
    $archive = "/root/$base"
    $installed = "/etc/webmin/version"

    class dependencies {
        package { "perl": ensure => installed }
        package { "libnet-ssleay-perl": ensure => installed }
        package { "openssl": ensure => installed }
        package { "libauthen-pam-perl": ensure => installed }
        package { "libpam-runtime": ensure => installed }
        package { "libio-pty-perl": ensure => installed }
        package { "apt-show-versions": ensure => installed }
        package { "python": ensure => installed }
    }

    include webmin::dependencies

    service { webmin:
        ensure => running,
        require => Exec["InstallWebmin"],
        provider => init;
    }

    exec { "DownloadWebmin":
        cwd => "/root",
        command => "wget $url$base",
        creates => $archive,
    }

    exec { "InstallWebmin":
        cwd => "/root",
        command => "dpkg -i $archive",
        creates => $installed,
        require => [Exec["DownloadWebmin"], Class['webmin::dependencies']],
        notify => Service[webmin],
    }
}