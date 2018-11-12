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
  if ( $::facts['oracle_instantclient_versions'] ) {
    $installed_client_version = $::facts['oracle_instantclient_versions']
    notify { "INSTALLED: ${installed_client_version}": }

    $package_version_array = split($installed_client_version, '.')

    $package_version_array.each |String $item| {
      notify { "ITEM: ${item}": }
    }

    $installed_major = $package_version_array[0]
    $installed_minor = $package_version_array[1]
    notify { "MAJOR: ${installed_major}": }
    notify { "MINOR: ${installed_minor}": }
  }

  $package_name_basic = "oracle-instantclient${installed_major}.${installed_minor}-basic"
  $requested_client_version = "${php_oci8::instantclient_major}.${php_oci8::instantclient_minor}.${php_oci8::instantclient_patch_a}.${php_oci8::instantclient_patch_b}.${php_oci8::instantclient_patch_c}"
  notify { "REQUESTED: ${requested_client_version}": }

  if ( $requested_client_version and $installed_client_version ) {
    if $requested_client_version == $installed_client_version {
      notify { 'Installed and requested client versions match, exiting.':
        loglevel => debug,
      }
    }
    else {
      notify { "Uninstalling instant client ${installed_client_version}.":
        notify   => Package[$package_name_basic],
        loglevel => debug,
      }

      # Uninstall basic package
      package { $package_name_basic:
        ensure   => absent,
        provider => $package_provider,
      }

    }
  }

}
