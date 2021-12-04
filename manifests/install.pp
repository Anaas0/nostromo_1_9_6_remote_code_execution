#
class nostromo_1_9_6_remote_code_execution::install {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ], environment => [ 'http_proxy=172.22.0.51:3128', 'https_proxy=172.22.0.51:3128' ] }
  #$secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $user = 'nostromousr'#$secgen_parameters['leaked_username'][0]
  $user_home = "/home/${user}"
  $release_dir = '/home/nostromousr/nostromo-1.9.6/src/nhttpd'
  $config_file_dir = '/var/nostromo/conf'

  exec { 'set-nic-dhcp':
    command   => 'sudo dhclient ens3',
    notify    => Exec['set-sed'],
    logoutput => true,
  }
  exec { 'set-sed':
    command   => "sudo sed -i 's/172.33.0.51/172.22.0.51/g' /etc/systemd/system/docker.service.d/* /etc/environment /etc/apt/apt.conf /etc/security/pam_env.conf",
    notify    => Package['make'],
    logoutput => true,
  }

  # Install dependancies - make, gcc libssl-dev
  ensure_packages('make')
  ensure_packages('gcc')
  ensure_packages('libssl-dev')

  # Move tar ball to /home/nostromo/
  file { "${user_home}/nostromo_1_9_6.tar.gz":
    source  => 'puppet:///modules/nostromo_1_9_6_remote_code_execution/nostromo_1_9_6.tar.gz',
    owner   => $user,
    mode    => '0777',
    require => User[$user],
    notify  => Exec['mellow-file'],
  }

  # Extract the tar ball
  exec { 'mellow-file':
    cwd     => "${user_home}/",
    command => 'tar -xzvf nostromo_1_9_6.tar.gz',
    creates => "${user_home}/nostromo-1.9.6/",
    require => File["${user_home}/nostromo_1_9_6.tar.gz"],
    notify  => Exec['make-nostromo'],
  }

  # Make the application
  exec { 'make-nostromo':
    cwd     => "${user_home}/nostromo-1.9.6/",
    command => 'sudo make',
    require => Exec['mellow-file'],
    notify  => Exec['make-nostromo-install'],
  }

  # Install the application
  exec { 'make-nostromo-install':
    cwd     => "${user_home}/nostromo-1.9.6/",
    command => 'sudo make install',
    require => Exec['make-nostromo'],
    notify  => Exec['restart-networking'],
  }

  ############################################## ~PROXY SETTINGS UNDO START~ ##############################################

  exec { 'restart-networking':
    command => 'service networking restart',
    require => Exec['make-nostromo-install'],
    notify  => File["${config_file_dir}/nhttpd.conf"],
  }
  ##############################################  ~PROXY SETTINGS UNDO END~  ##############################################
}
