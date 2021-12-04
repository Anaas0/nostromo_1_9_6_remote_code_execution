#
class nostromo_1_9_6_remote_code_execution::service {
  require nostromo_1_9_6_remote_code_execution::config
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]}
  $user = 'nostromousr'#$secgen_parameters['leaked_username'][0]
  $user_home = "/home/${user}"
  $release_dir = '/home/nostromousr/nostromo-1.9.6/src/nhttpd'
  $config_file_dir = '/var/nostromo/conf'
  $service_file_dir = '/etc/systemd/system'

  # Move service file to /home/nostromousr/nostromo-1.9.6/src/nhttpd
  file { "${release_dir}/nhttpd.service":
    source  => 'puppet:///modules/nostromo_1_9_6_remote_code_execution/nhttpd.service',
    owner   => 'nostromousr',
    mode    => '0777',
    require => Exec['set-log-dir-perms'],
    notify  => File["${service_file_dir}/nhttpd.service"],
  }

  # Service file in /etc/systemd/system/
  file { "${service_file_dir}/nhttpd.service":
    source  => 'puppet:///modules/nostromo_1_9_6_remote_code_execution/nhttpd.service',
    owner   => 'nostromousr',
    mode    => '0777',
    require => File["${release_dir}/nhttpd.service"],
    notify  => Exec['run-nhttpd'],
  }

  exec { 'run-nhttpd':
    command => "sudo /home/${user}/nostromo-1.9.6/src/nhttpd/nhttpd",
    notify  => Service['nhttpd'],
    require => File["${service_file_dir}/nhttpd.service"],
  }

  service { 'nhttpd':
    ensure  => running,
    enable  => true,
    require => Exec['run-nhttpd'],
  }
}
