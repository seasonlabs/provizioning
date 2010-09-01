package :syslog do
  apt 'sysklogd'

  verify do
    has_log '/sbin/syslogd'
  end
end