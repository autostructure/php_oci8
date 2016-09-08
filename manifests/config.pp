#
# == Class php_oci8::config
#
# This class is called from php_oci8 for service config.
#
#

class php_oci8::config {

  exec {'update pecl channel for pecl.php.net':
    command => 'pecl channel-update pecl.php.net',
    path    => ['/bin', '/usr/bin',],
    user    => root,
    timeout => 0,
    tries   => 5,
    unless  => '/usr/bin/php -m | grep -c oci8',
    before  => Exec['pecl-install-oci8'],
  }

  exec {'pecl-install-oci8':
    command => "pecl install oci8-${::php_oci8::pecl_oci8_version} </tmp/answers-pecl-oci8-${::php_oci8::major}.${::php_oci8::minor}.txt",
    path    => ['/bin', '/usr/bin',],
    user    => root,
    timeout => 0,
    tries   => 5,
    unless  => '/usr/bin/php -m | grep -c oci8',
    before  => File['add-oci8-extension'],
  }

  #file_line {'add-oci8-php.ini':
  #  path => '/etc/php.ini',
  #  line => 'extension=oci8.so',
  #}

  file {'add-oci8-extension':
    ensure  => file,
    path    => '/etc/php.d/20-oci8.ini',
	  owner   => 'root',
	  group   => 'root',
	  mode    => '0644',
	  content => "extension=oci8.so\n",
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
