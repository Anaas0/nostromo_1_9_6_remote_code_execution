#
class nostromo_1_9_6_remote_command_execution::config {
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ], environment => [ 'http_proxy=172.22.0.51:3128', 'https_proxy=172.22.0.51:3128' ] }

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
    require => Exec['make-nostromo-install'],
  }

  # Set /var/nostromo/logs to 777

  # Next steps in Service file
}
