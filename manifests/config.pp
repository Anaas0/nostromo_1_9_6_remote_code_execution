#
class nostromo_1_9_6_remote_code_execution::config {
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]}

  user { 'nostromousr':
    ensure     => present,
    uid        => '666',
    gid        => 'root',#
    home       => '/home/nostromousr',
    managehome => true,
    password   => 'toor', # Temp, remove in final.
    require    => Package['libssl-dev'],
    notify     => File['/home/nostromousr/nostromo_1_9_6.tar.gz'],
  }

  # Copy the config file to /var/nostromo/conf/
  file { '/var/nostromo/conf/nhttpd.conf':
    source  => '/home/unhcegila/puppet-modules/nostromo_1_9_6_remote_code_execution/files/nhttpd.conf',
    owner   => 'nostromousr',
    require => Exec['make-nostromo-install'],
    notify  => Exec['set-log-dir-perms'],
  }

  # Set /var/nostromo/logs to 777
  exec { 'set-log-dir-perms':
    command => 'sudo chmod 777 /var/nostromo/logs',
    require => File['/var/nostromo/conf/nhttpd.conf'],
    notify  => File['/home/nostromousr/nostromo-1.9.6/src/nhttpd/nhttpd.service'],
  }
  # Next steps in Service file
}
