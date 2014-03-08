# == Class cdh4::hadoop::defaults
# Default parameters for cdh4::hadoop configuration.
#
class cdh4::hadoop::defaults {
  $config_directory                        = '/etc/hadoop/conf'
  $datanode_mounts                         = undef
  $dfs_data_path                           = 'hdfs/dn'
  $yarn_local_path                         = 'yarn/local'
  $yarn_logs_path                          = 'yarn/logs'
  $dfs_block_size                          = 67108864 # 64MB default
  $enable_jmxremote                        = true
  $enable_webhdfs                          = true
  $io_file_buffer_size                     = undef
  $mapreduce_system_dir			   = undef
  $mapreduce_map_tasks_maximum             = undef
  $mapreduce_reduce_tasks_maximum          = undef
  $mapreduce_job_reuse_jvm_num_tasks       = undef
  $mapreduce_reduce_shuffle_parallelcopies = undef
  $mapreduce_map_memory_mb                 = 2048
  $mapreduce_reduce_memory_mb              = undef
  $mapreduce_task_io_sort_mb               = 10
  $mapreduce_task_io_sort_factor           = undef
  $mapreduce_map_java_opts                 = '-Xmx2048m -server'
  $mapreduce_reduce_java_opts              = undef
  $mapreduce_intermediate_compression      = true
  $mapreduce_final_compression             = false
  $yarn_nodemanager_resource_memory_mb     = undef
  $yarn_resourcemanager_scheduler_class    = undef
  $use_yarn                                = true
  $enable_lzo                              = false
  $replication_factor			   = 3
}
