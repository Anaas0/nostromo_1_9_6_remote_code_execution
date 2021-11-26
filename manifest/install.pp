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
    ensure => installed,
    notify => Package['libssl-dev'],
  }
  package { 'libssl-dev':
    ensure => installed,
    notify => Package['nostromousr'],
  }
  ensure_packages('make', 'gcc', 'libssl-dev')


}
