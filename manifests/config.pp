#
class nostromo_1_9_6_remote_code_execution::config {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]}
  #$secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $port = '8080'#$secgen_parameters['port'][0]
  $user = 'nostromousr'#$secgen_parameters['leaked_username'][0]
  $user_home = "/home/${user}"
  $release_dir = '/home/nostromousr/nostromo-1.9.6/src/nhttpd'
  $config_file_dir = '/var/nostromo/conf'

  user { "${user}":
    ensure     => present,
    uid        => '666',
    gid        => 'root',#
    home       => "${user_home}/",
    managehome => true,
    password   => 'toor', # Temp, remove in final.
    require    => Package['libssl-dev'],
    notify     => File["${user_home}/nostromo_1_9_6.tar.gz"],
  }

  # Copy the config file to /var/nostromo/conf/
  file { "${config_file_dir}/nhttpd.conf":
    source  => 'puppet:///modules/nostromo_1_9_6_remote_code_execution/nhttpd.conf',
    owner   => $user,
    require => Exec['make-nostromo-install'],
    notify  => Exec['set-log-dir-perms'],
  }

  # Set /var/nostromo/logs to 777
  exec { 'set-log-dir-perms':
    command => 'sudo chmod 777 /var/nostromo/logs',
    require => File["${config_file_dir}/nhttpd.conf"],
    notify  => File["${release_dir}/nhttpd.service"],
  }
  # Next steps in Service file
}
