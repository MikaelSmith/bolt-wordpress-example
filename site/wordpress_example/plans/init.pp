plan wordpress_example(TargetSpec $nodes) {
  run_plan('facts', nodes => $nodes)
  $report = apply($nodes) {
    class { 'apache':
      docroot => '/opt/wordpress'
    }
    class { 'apache::mod::php': }
    class { 'mysql::server':
      root_password           => lookup('wordpress_example::mysql_password'),
      remove_default_accounts => true,
    }
    class { 'mysql::bindings':
      php_enable => true,
    }
    class { 'wordpress': }
  }

  $report.each |$node| {
    # Fail plan if any failed resources
    $failed_resources = $node.value['resource_statuses'].filter |$key, $value| { $value['failed'] }
    if !empty($failed_resources) {
      fail($failed_resources)
    }
  }

  $report.map |$r| { $r.value['logs'] }
}
