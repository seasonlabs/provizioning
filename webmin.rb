package :webmin, :provides => :panel do
  description 'Webmin'
  version '1.510'
  requires :webmin_dependencies

  deb "http://prdownloads.sourceforge.net/webadmin/webmin_#{version}-2_all.deb"
  
  verify do
    has_file "/etc/webmin/start"
  end
end

package :webmin_dependencies do
  description 'Webmin dependencies'
  apt 'apt-show-versions perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl'
end
  