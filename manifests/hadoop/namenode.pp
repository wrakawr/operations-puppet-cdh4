# == Class cdh4::hadoop::namenode
# Installs and configureds Hadoop NameNode.
# This will format the NameNode if it is not
# already formatted.  It will also create
# a common HDFS directory hierarchy.
#
class cdh4::hadoop::namenode {
  require cdh4::hadoop

  # install namenode daemon package
  package { 'hadoop-hdfs-namenode':
    ensure => installed
  }

  file { "${::cdh4::hadoop::config_directory}/hosts.exclude":
    ensure  => 'present',
    require => Package['hadoop-hdfs-namenode'],
  }

  # Ensure that the namenode directory has the correct permissions.
  # NOTE! You should create, mount and hdfs format this directory
  # manually yourself.
  # To format the dfs_name_dir, run:
  #   sudo -u hdfs hadoop namenode -format
  file { $::cdh4::hadoop::dfs_name_dir:
    ensure  => 'directory',
    owner   => 'hdfs',
    group   => 'hdfs',
    mode    => '0700',
    require => Package['hadoop-hdfs-namenode'],
  }

  # If $dfs_name_dir/current/VERSION doesn't exist, assume
  # NameNode has not been formated.  Format it before
  # the namenode service is started.
  # Note: $dfs_name_dir might be an array.
  #       We only want to check the first entry.
  $dfs_name_dir      = $::cdh4::hadoop::dfs_name_dir
  $dfs_name_dir_main = inline_template('<%= (dfs_name_dir.class == Array) ? dfs_name_dir[0] : dfs_name_dir %>')
  exec { 'hadoop-namenode-format':
    command => '/usr/bin/hdfs namenode -format',
    creates => "${dfs_name_dir_main}/current/VERSION",
    user    => 'hdfs',
    require => File[$::cdh4::hadoop::dfs_name_dir],
  }

  service { 'hadoop-hdfs-namenode':
    ensure  => 'running',
    enable  => true,
    alias   => 'namenode',
    require => [File["${::cdh4::hadoop::config_directory}/hosts.exclude"], Exec['hadoop-namenode-format']],
  }

  # Create common HDFS directories.
  # Make sure NameNode is running before we try to create these.
  Cdh4::Hadoop::Directory {
    require => Service['hadoop-hdfs-namenode'],
  }
  cdh4::hadoop::directory {
    # sudo -u hdfs hadoop fs -mkdir /tmp
    # sudo -u hdfs hadoop fs -chmod 1777 /tmp
    '/tmp':
      owner => 'hdfs',
      group => 'hdfs',
      mode  => '1777';

    # sudo -u hdfs hadoop fs -mkdir /user
    # sudo -u hdfs hadoop fs -chmod 0775 /user
    # sudo -u hdfs hadoop fs -chown hdfs:hadoop /user
    '/user':
      owner => 'hdfs',
      group => 'hadoop',
      mode  => '0775';

    # sudo -u hdfs hadoop fs -mkdir /user/hdfs
    '/user/hdfs':
      owner => 'hdfs',
      group => 'hdfs',
      mode  => '0755';

    # sudo -u hdfs hadoop fs -mkdir /var
    '/var':
      owner => 'hdfs',
      group => 'hdfs',
      mode  => '0755';

    # sudo -u hdfs hadoop fs -mkdir /var/lib
    '/var/lib':
      owner   => 'hdfs',
      group   => 'hdfs',
      mode    => '0755',
      require => Cdh4::Hadoop::Directory['/var'];

    # sudo -u hdfs hadoop fs -mkdir /var/log
    '/var/log':
      owner   => 'hdfs',
      group   => 'hdfs',
      mode    => '0755',
      require => Cdh4::Hadoop::Directory['/var'];
  }
}
