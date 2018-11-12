# == Class php_oci8::uninstall instant client during upgrade/downgrade
#
# Author: Paul Talbot, Autostructure
#
# ===============================================
#
# ===============================================
#
# @summary
#   Called by init to uninstall Oracle instant client if necessary
#

class php_oci8::uninstall {

  # determine package provider for package resource below
  case $facts['kernel'] {
    'Linux' : {
      case $facts['os']['family'] {
        'RedHat' : {
          $package_provider = 'rpm'
        }
        default : {
          fail ("Unsupported OS family ${$facts['os']['family']}.") }
      }
    }
    default : {
      fail ("Unsupported platform ${$facts['kernel']}.") }
  }

  # set a variable from fact containing already-installed instant client version to
  #   compare with requested version from hiera
  if ( $::facts['oracle_instantclient_versions'] != { } ) {
    $installed_client_version = $::facts['oracle_instantclient_versions']
    $package_version_array = split($installed_client_version, '\.')
    $installed_major = $package_version_array[0]
    $installed_minor = $package_version_array[1]
  }

  $package_name_basic = "oracle-instantclient${installed_major}.${installed_minor}-basic"
  $package_name_devel = "oracle-instantclient${installed_major}.${installed_minor}-devel"
  $requested_client_version = "${php_oci8::instantclient_major}.${php_oci8::instantclient_minor}.${php_oci8::instantclient_patch_a}.${php_oci8::instantclient_patch_b}.${php_oci8::instantclient_patch_c}"

  if ( $requested_client_version and $installed_client_version ) {
    if $requested_client_version == $installed_client_version {
      notify { 'Installed and requested client versions match, exiting.':
        loglevel => debug,
      }
    }
    else {
      notify { "Uninstalling instant client ${installed_client_version}":
        notify   => [ Exec['uninstall previous pecl oci8 extension'], Package[$package_name_devel], Package[$package_name_basic] ],
        loglevel => debug,
      }

      # Uninstall devel package
      package { $package_name_devel:
        ensure   => absent,
        provider => $package_provider,
      }

      # Uninstall basic package
      package { $package_name_basic:
        ensure   => absent,
        provider => $package_provider,
      }

      # Uninstall pecl oci8 extension to eliminate errors on upgrade
      exec {'uninstall previous pecl oci8 extension':
        command     => 'pecl uninstall oci8',
        path        => ['/bin', '/usr/bin',],
        user        => root,
        timeout     => 0,
        tries       => 5,
        refreshonly => true,
        #before      => Exec['pecl-install-oci8'],
      }
    }
  }

}
