# == Class php_oci8::config
#
# Author: Paul Talbot, Autostructure
#
# ===============================================
# TODO: refine logic to compare installed pecl oci8 extention to what
#       is specified in hiera
# ===============================================
#
# @summary
#   Called by init (after install class) to configure Oracle OCI8 for PHP on Linux
#

class php_oci8::config {

  # Apache included for restart after oracle home
  #include ::apache

  exec {'update pecl channel for pecl.php.net':
    command => 'pecl channel-update pecl.php.net',
    path    => ['/bin', '/usr/bin',],
    user    => root,
    timeout => 0,
    tries   => 5,
    unless  => '/usr/bin/php -m | grep -c oci8',
    before  => Exec['pecl-install-oci8'],
  }

  notify { "FACT: ${::facts}['pecl_oci8_version']['version']['full']": }
  notify { "Without fact.": }

  #if $::facts['pecl_oci8_version']['version']['full'] == ${::php_oci8::pecl_oci8_version} {
  #  #notice ("Evaluation: ${facts}['pecl_oci8_extension']['version']['full'] MATCHES ${::php_oci8::pecl_oci8_version}")
  #  notify { 'TRUE: should produce output.': }
  #}
  #else {
  #  #notice ("Evaluation: ${facts}['pecl_oci8_extension']['version']['full'] DOES NOT MATCH ${::php_oci8::pecl_oci8_version}")
  #  notify { 'FALSE: should produce output.': }
  #}

  exec {'pecl-install-oci8':
    command => "pecl install oci8-${::php_oci8::pecl_oci8_version} </tmp/answers-pecl-oci8-${::php_oci8::instantclient_major}.${::php_oci8::instantclient_minor}.txt",
    path    => ['/bin', '/usr/bin',],
    user    => root,
    timeout => 0,
    tries   => 5,
    #unless  => $pecl_version_match,
    before  => File['add-oci8-extension'],
  }

  file {'add-oci8-extension':
    ensure  => file,
    path    => '/etc/php.d/20-oci8.ini',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "extension=oci8.so\n",
  }

  file_line {'env-oracle-home':
    path  => '/etc/environment',
    line  => "export ORACLE_HOME=/usr/lib/oracle/${::php_oci8::instantclient_major}.${::php_oci8::instantclient_minor}/client64/lib",
    match => '^export\ ORACLE_HOME\=',
    #notify => Service['httpd'],
  }

  file_line {'env-oracle-nls-date-format':
    path  => '/etc/environment',
    line  => "export NLS_DATE_FORMAT=\"DD/MM/YYYY HH24:MI\"",
    match => '^export\ NLS_DATE_FORMAT\=',
    #notify => Service['httpd'],
  }

}
