# == Class php_oci8::config
#
# Author: Paul Talbot, FFI
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

  # set a variable from fact containing already-installed extension version to
  #   compare with requested version from hiera
  if ( $::facts['pecl_oci8_extension'] ) {
    if ( $::facts['pecl_oci8_extension']['version'] ) {
      if ( $::facts['pecl_oci8_extension']['version']['full'] ) {
        $installed_version = $::facts['pecl_oci8_extension']['version']['full']
      }
    }
  }

  # set a variable from hiera value containing desired extension version to
  #   compare with already-installed version in fact
  $requested_version = $::php_oci8::pecl_oci8_version

  if ( $requested_version and $installed_version != { } ) {
    if $requested_version == $installed_version {
      #notify { 'Installed and requested pecl oci8 extension versions match, exiting':
      #  loglevel => debug,
    }
  }
  else {
    notify { "Change pecl oci8 \"${installed_version}\" to \"${requested_version}\"":
      notify   => [ Exec['uninstall pecl oci8 extension'], Exec['install pecl oci8 extension'] ],
      loglevel => debug,
    }
  }

  exec {'update pecl channel for pecl.php.net':
    command     => 'pecl channel-update pecl.php.net',
    path        => ['/bin', '/usr/bin',],
    user        => root,
    timeout     => 0,
    tries       => 5,
    refreshonly => true,
    before      => Exec['install pecl oci8 extension'],
    notify      => Exec['uninstall pecl oci8 extension'],
  }

  exec {'uninstall pecl oci8 extension':
    command     => 'pecl uninstall oci8',
    path        => ['/bin', '/usr/bin',],
    user        => root,
    timeout     => 0,
    tries       => 5,
    refreshonly => true,
    onlyif      => 'pecl list oci8',
    before      => Exec['install pecl oci8 extension'],
  }

  exec {'install pecl oci8 extension':
    command     => "pecl install oci8-${::php_oci8::pecl_oci8_version} </tmp/answers-pecl-oci8-${::php_oci8::instantclient_major}.${::php_oci8::instantclient_minor}.txt",
    path        => ['/bin', '/usr/bin',],
    user        => root,
    timeout     => 0,
    tries       => 5,
    refreshonly => true,
    onlyif      => '/usr/bin/test `/bin/rpm -qa oracle-instantclient* | wc -l` -ge 2',
    before      => File['add-oci8-extension'],
    notify      => Exec['restart php-fpm'],
  }

  exec {'restart php-fpm':
    command     => 'systemctl restart php-fpm',
    path        => ['/bin', '/usr/bin',],
    user        => root,
    timeout     => 0,
    tries       => 5,
    refreshonly => true,
  }

  file {'add-oci8-extension':
    ensure  => file,
    path    => '/etc/php.d/20-oci8.ini',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "extension=oci8.so\n",
    before  => File_line['env-oracle-home'],
  }

  file_line {'env-oracle-home':
    path   => '/etc/environment',
    line   => "export ORACLE_HOME=/usr/lib/oracle/${::php_oci8::instantclient_major}.${::php_oci8::instantclient_minor}/client64/lib",
    match  => '^export\ ORACLE_HOME\=',
    before => File_line['env-oracle-nls-date-format'],
  }

  file_line {'env-oracle-nls-date-format':
    path  => '/etc/environment',
    line  => "export NLS_DATE_FORMAT=\"DD/MM/YYYY HH24:MI\"",
    match => '^export\ NLS_DATE_FORMAT\=',
  }

}
