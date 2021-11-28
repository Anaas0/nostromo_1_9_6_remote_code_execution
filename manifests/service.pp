#
class nostromo_1_9_6_remote_code_execution::service {
  require nostromo_1_9_6_remote_code_execution::config
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]}

  # Move service file to /home/nostromousr/nostromo-1.9.6/src/nhttpd
  file { '/home/nostromousr/nostromo-1.9.6/src/nhttpd/nhttpd.service':
    source  => '/home/unhcegila/puppet-modules/nostromo_1_9_6_remote_code_execution/files/nhttpd.service',
    owner   => 'nostromousr',
    mode    => '0777',
    require => Exec['set-log-dir-perms'],
    notify  => File['/etc/systemd/system/nhttpd.service'],
  }

  # Service file in /etc/systemd/system/
  file { '/etc/systemd/system/nhttpd.service':
    source  => '/home/unhcegila/puppet-modules/nostromo_1_9_6_remote_code_execution/files/nhttpd.service',
    owner   => 'nostromousr',
    mode    => '0777',
    require => File['/home/nostromousr/nostromo-1.9.6/src/nhttpd/nhttpd.service'],
    notify  => Service['nhttpd'],
  }

  service { 'nhttpd':
    ensure  => running,
    enable  => true,
    require => File['/etc/systemd/system/nhttpd.service'],
  }
}
