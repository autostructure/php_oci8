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
  # NOTE: commented out since we are using php-fpm
  #include ::apache

  exec {'update pecl channel for pecl.php.net':
    command     => 'pecl channel-update pecl.php.net',
    path        => ['/bin', '/usr/bin',],
    user        => root,
    timeout     => 0,
    tries       => 5,
    # unless  => '/usr/bin/php -m | grep -c oci8
    refreshonly => true,
    before      => Exec['pecl-install-oci8'],
  }

  if ( $::facts['pecl_oci8_extension'] ) {
    if ( $::facts['pecl_oci8_extension']['version'] ) {
      if ( $::facts['pecl_oci8_extension']['version']['full'] ) {
        #notify { "FACT: ${::facts['pecl_oci8_extension']['version']['full']}": }
        $installed_version = $::facts['pecl_oci8_extension']['version']['full']
        #notify { "VARIABLE: ${installed_version}": }
      }
    }
  }

  $requested_version = $::php_oci8::pecl_oci8_version
  notify { "HIERA: ${requested_version}": }

  if ( $requested_version and $installed_version ) {
    if ( $requested_version != $installed_version ) {
      exec {'uninstall previous pecl oci8 extension':
        command     => "pecl uninstall oci8-${installed_version}",
        path        => ['/bin', '/usr/bin',],
        user        => root,
        timeout     => 0,
        tries       => 5,
        refreshonly => true,
        before      => Exec['pecl-install-oci8'],
      }
    }
  }
  else {
    fail('One or more elements to compare are missing values.')
  }

  exec {'pecl-install-oci8':
    command     => "pecl install oci8-${::php_oci8::pecl_oci8_version} </tmp/answers-pecl-oci8-${::php_oci8::instantclient_major}.${::php_oci8::instantclient_minor}.txt",
    path        => ['/bin', '/usr/bin',],
    user        => root,
    timeout     => 0,
    tries       => 5,
    refreshonly => true,
    before      => File['add-oci8-extension'],
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
