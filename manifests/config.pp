# == Class php_oci8::config
#
# This class is called from php_oci8 for service config.
#

class php_oci8::config {

  exec {'update pecl channel for pecl.php.net':
    command => '/bin/pecl channel-update pecl.php.net',
    path    => ['/bin', '/usr/bin',],
    user    => root,
    timeout => 0,
    tries   => 5,
    unless  => '/usr/bin/php -m | grep -c oci8',
    before  => Exec['pecl-install-oci8'],
  }

  exec {'pecl-install-oci8':
    command => "/bin/pecl install oci8-${::php_oci8::pecl_oci8_version} </tmp/answers-pecl-oci8-${::php_oci8::major}.${::php_oci8::minor}.txt",
    path    => ['/bin', '/usr/bin',],
    user    => root,
    timeout => 0,
    tries   => 5,
    unless  => '/usr/bin/php -m | grep -c oci8',
  }

  file_line {'add-oci8-php':
    path => '/etc/php.ini',
    line => 'extension=oci8.so',
  }

  file_line {'env-oracle-home':
    path   => '/etc/environment',
    line   => "export ORACLE_HOME=/usr/lib/oracle/${::php_oci8::major}.${::php_oci8::minor}/client64/lib",
    match  => '^export\ ORACLE_HOME\=',
    notify => Service['httpd'],
  }

  file_line {'env-oracle-nls-date-format':
    path   => '/etc/environment',
    line   => "export NLS_DATE_FORMAT=\"DD/MM/YYYY HH24:MI\"",
    match  => '^export\ NLS_DATE_FORMAT\=',
    notify => Service['httpd'],
  }

}
