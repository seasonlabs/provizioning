class webmin {
    $base = "webmin_1.480_all.deb"
    $url = "http://prdownloads.sourceforge.net/webadmin/"
    $archive = "/root/$base"
    $installed = "/etc/webmin/version"

    package { "libnet-ssleay-perl": ensure => installed }
    package { "libauthen-pam-perl": ensure => installed }
    package { "libio-pty-perl": ensure => installed }
    package { "libmd5-perl": ensure => installed }

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
        require => Exec["DownloadWebmin"],
        notify => Service[webmin],
    }
}