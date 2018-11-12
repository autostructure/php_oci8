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

  # set a variable from fact containing already-installed extension version to
  #   compare with requested version from hiera
  if ( $::facts['pecl_oci8_extension'] ) {
    if ( $::facts['pecl_oci8_extension']['version'] ) {
      if ( $::facts['pecl_oci8_extension']['version']['full'] ) {
        $installed_version = $::facts['pecl_oci8_extension']['version']['full']
        #notify { "INSTALLED: ${installed_version}": }
      }
    }
  }

  # set a variable from hiera value containing desired extension version to
  #   compare with already-installed version in fact
  $requested_version = $::php_oci8::pecl_oci8_version

  if ( $requested_version and $installed_version ) {
    if $requested_version == $installed_version {
      notify { 'Installed and requested pecl oci8 extension versions match, exiting.':
        loglevel => debug,
      }
    }
    else {
      notify { "Switching from pecl oci8 ${installed_version} to ${requested_version}.":
        notify   => [ Exec['uninstall pecl oci8 extension'], Exec['pecl-install-oci8'] ],
        loglevel => debug,
      }
    }
  }

  exec {'update pecl channel for pecl.php.net':
    command     => 'pecl channel-update pecl.php.net',
    path        => ['/bin', '/usr/bin',],
    user        => root,
    timeout     => 0,
    tries       => 5,
    refreshonly => true,
    before      => Exec['pecl-install-oci8'],
    notify      => Exec['uninstall pecl oci8 extension'],
  }

  exec {'uninstall pecl oci8 extension':
    command     => 'pecl uninstall oci8}',
    path        => ['/bin', '/usr/bin',],
    user        => root,
    timeout     => 0,
    tries       => 5,
    refreshonly => true,
    before      => Exec['pecl-install-oci8'],
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
