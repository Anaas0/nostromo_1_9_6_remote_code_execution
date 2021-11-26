#
class nostromo_1_9_6_remote_command_execution::config {
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ], environment => [ 'http_proxy=172.22.0.51:3128', 'https_proxy=172.22.0.51:3128' ] }

  user { 'nostromousr':
    ensure     => present,
    uid        => '666',
    gid        => 'root',#
    home       => '/home/nostromousr',
    managehome => true,
    notify     => File[''],
  }
}
