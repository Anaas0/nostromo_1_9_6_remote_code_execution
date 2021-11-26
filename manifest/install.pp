#
class nostromo_1_9_6_remote_command_execution::install {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ], environment => [ 'http_proxy=172.22.0.51:3128', 'https_proxy=172.22.0.51:3128' ] }
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
  package { 'make':
    ensure => installed,
    notify => Package['gcc'],
  }
  package { 'gcc':
    ensure  => installed,
    require => Package['make'],
    notify  => Package['libssl-dev'],
  }
  package { 'libssl-dev':
    ensure  => installed,
    require => Package['gcc'],
    notify  => Package['nostromousr'],
  }
  ensure_packages('make', 'gcc', 'libssl-dev')

  # Move tar ball to /home/user/
  file { '/home/nostromousr/nostromo_1_9_6.tar.gz':
    source  => '/home/unhcegila/puppet-modules/nostromo_1_9_6_remote_command_execution/files/nostromo_1_9_6.tar.gz',
    owner   => 'nostromousr',
    mode    => '0777',
    require => User['nostromousr'],
    notify  => Exec['mellow-file'],
  }

  # Extract the tar ball
  exec { 'mellow-file':
    cwd     => '/home/nostromousr/',
    command => 'tar -xzvf nostromo_1_9_6.tar.gz',
    creates => '/home/nostromousr/nostromo-1.9.6/',
    require => File['/home/nostromousr/nostromo_1_9_6.tar.gz'],
    notify  => Exec['make-nostromo'],
  }

  # Make the application
  exec { 'make-nostromo':
    cwd     => '/home/nostromousr/',
    command => 'sudo make',
    require => Exec['mellow-file'],
    notify  => Exec['make-nostromo-install'],
  }

  # Install the application
  exec { 'make-nostromo-install':
    cwd     => '/home/nostromousr/',
    command => 'sudo make install',
    require => Exec['make-nostromo'],
    notify  => Exec['restart-networking'],
  }

  ############################################## ~PROXY SETTINGS UNDO START~ ##############################################

  exec { 'restart-networking':
    command => 'service networking restart',
    require => Exec['make-nostromo-install'],
    notify  => Exec['/var/nostromo/conf/nhttpd.conf'],
  }
  ##############################################  ~PROXY SETTINGS UNDO END~  ##############################################
}
