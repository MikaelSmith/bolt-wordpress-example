plan wordpress_example(TargetSpec $nodes) {
  run_task('puppet_agent::install', $nodes)

  $result = run_plan('facts', nodes => $nodes)
  if !$result.ok {
    return $result.error_set
  }

  $report = apply($nodes) {
    class { 'apache':
      docroot    => '/opt/wordpress',
      mpm_module => 'prefork',
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

  return $report.map |$r| {
    ["Applying catalog on ${$r.target.name}"] + $r.value['logs'].map |$log| {
      "[${$log['level'].capitalize}]: ${$log['source']}: ${$log['message']}"
    }
  }
}
