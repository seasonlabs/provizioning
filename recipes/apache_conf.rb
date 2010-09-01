package :apache_conf do
  transfer '../templates/apache.conf.erb', '/etc/nginx.conf', :render => true
end