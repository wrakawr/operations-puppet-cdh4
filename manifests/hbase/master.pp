# == Class cdh4::hbase::master
# Installs HBase master
#
class cdh4::hbase::master(
  $regionservers    = undef,
) {

  Class['cdh4::hbase'] -> Class['cdh4::hbase::master']

  package { 'hbase-master': 
    ensure => 'installed',
  }


  if ($regionservers == undef) {
    fail("you must provide list of regionservers hosts")
  }

  file { "${::cdh4::hbase::config_directory}/regionservers":
    content => template('cdh4/hbase/regionservers.erb'),
  }


  service { 'hbase-master':
    ensure      => 'running',
    enable      => true,
    hasrestart  => true,
    require     => [ File["${::cdh4::hbase::config_directory}/hbase-site.xml"], File["${::cdh4::hbase::config_directory}/regionservers"], File["${::cdh4::hbase::config_directory}/hbase-env.sh"], ],
    subscribe   => [ File["${::cdh4::hbase::config_directory}/hbase-site.xml"], File["${::cdh4::hbase::config_directory}/regionservers"], File["${::cdh4::hbase::config_directory}/hbase-env.sh"], ], 
  }


  package { 'hbase-thrift':
    ensure => 'installed',
  }

  service { 'hbase-thrift':
    ensure      => 'running',
    enable      => true,
    hasrestart  => true,
    require     => [ File["${::cdh4::hbase::config_directory}/hbase-site.xml"], File["${::cdh4::hbase::config_directory}/regionservers"], ],
    subscribe   => [ File["${::cdh4::hbase::config_directory}/hbase-site.xml"], File["${::cdh4::hbase::config_directory}/regionservers"], ],
  }


  # sudo -u hdfs hadoop fs -mkdir /hbase
  # sudo -u hdfs hadoop fs -chown hbase /hbase
  cdh4::hadoop::directory { "${::cdh4::hbase::root_dir}":
    owner   => 'hbase',
    group   => 'hbase',
  }

}
