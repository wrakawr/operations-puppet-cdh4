# == Class cdh4::zookeeper::server
# Configures a zookeeper server.
# This requires that cdh4::zookeeper is installed
# And that the current nodes fqdn is an entry in the
# cdh4::zookeeper::hosts array.
#
# == Parameters
# $jmx_port      - JMX port.  Set this to false if you don't want to expose JMX.
# $log_file      - zookeeper.log file.  Default: /var/log/zookeeper/zookeeper.log
#
class cdh4::zookeeper::server(
  $jmx_port       = $::cdh4::zookeeper::defaults::jmx_port,
  $log_file       = $::cdh4::zookeeper::defaults::log_file,
  $env_template   = $::cdh4::zookeeper::defaults::env_template,
  $log4j_template = $::cdh4::zookeeper::defaults::log4j_template,
)
{
  # need zookeeper common package and config.
  require cdh4::zookeeper

  package { 'zookeeper-server':
    ensure  => 'installed',
  }

  file { $::cdh4::zookeeper::data_dir:
    ensure => 'directory',
    owner  => 'zookeeper',
    group  => 'zookeeper',
    mode   => '0755',
  }

  file { '/etc/zookeeper/conf/zookeeper-env.sh':
    content => template($env_template),
    require => Package['zookeeper-server'],
  }

  file { '/etc/zookeeper/conf/log4j.properties':
    content => template($log4j_template),
    require => Package['zookeeper-server'],
  }

  $zookeeper_hosts = $::cdh4::zookeeper::hosts
  # Infer this host's $myid from the index in the $zookeeper_hosts array.
  $myid = inline_template('<%= zookeeper_hosts.index(fqdn) %>')

  # init the zookeeper data dir
  exec { 'zookeeper-server-initialize':
    command => "/usr/bin/zookeeper-server-initialize --myid=${myid}",
    unless  => "/usr/bin/test -f ${::cdh4::zookeeper::data_dir}/myid",
    user    => 'zookeeper',
  }

  service { 'zookeeper-server':
    ensure     => running,
    require    => [Package['zookeeper-server'], File[ $::cdh4::zookeeper::data_dir]],
    hasrestart => true,
    hasstatus  => true,
    subscribe  => [
      File['/etc/zookeeper/conf/zoo.cfg'],
      File['/etc/zookeeper/conf/zookeeper-env.sh'],
      File['/etc/zookeeper/conf/log4j.properties']
    ],
  }
}