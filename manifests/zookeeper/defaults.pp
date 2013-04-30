# == Class cdh4::zookeeper::defaults
# Default zookeeper configs.
class cdh4::zookeeper::defaults {
  # NOTE: The order of this array matters.
  # The Zookeeper 'myid' will be infered by the index of a node's
  # fqdn in this array.  Changing the order will change the 'myid'
  # of zookeeper servers.
  $hosts           = [$::fqdn]

  $data_dir       = '/tmp/zookeeper'
  $log_file       = '/var/log/zookeeper/zookeeper.log'
  $jmx_port       = 9998

  $conf_template   = 'cdh4/zookeeper/zoo.cfg.erb'
  $env_template    = 'cdh4/zookeeper/zookeeper-env.sh.erb'
  $log4j_template  = 'cdh4/zookeeper/log4j.properties.erb'
}