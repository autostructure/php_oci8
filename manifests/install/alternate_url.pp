# == Class php_oci8::install::alternate_url
#
# Author: Paul Talbot, Autostructure
#
# ===============================================
#
# ===============================================
#
# @summary
#   Called by php_oci8::install class to install from non-default source
#

class php_oci8::install::alternate_url {

  # archive module is used to download packages
  include ::archive

  # this variable is used for storing installer binary for package resource
  $temp_location = $::facts['where_is_temp']
  file { $temp_location:
    ensure  => 'directory',
  }

  # package names from parent class
  $package_name_basic = $::php_oci8::alternate_package_name_basic
  $package_name_devel = $::php_oci8::alternate_package_name_devel

  # absolute paths to the installers
  $destination_basic = "${temp_location}/${package_name_basic}"
  $destination_devel = "${temp_location}/${package_name_devel}"
  #notice ("Destination for basic is ${destination_basic}.")
  #notice ("Destination for devel is ${destination_devel}.")

  # determine package provider for package resources below
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

  # alternat URL from parent class
  $alternate_url = $::php_oci8::alternate_url

  # get basic package installer from URL
  archive { "${destination_basic}.rpm":
    ensure  => present,
    source  => "${alternate_url}/${package_name_basic}.rpm",
    extract => false,
    creates => "${destination_basic}.rpm",
    cleanup => false,
  }

  # get devel package installer from URL
  archive { "${destination_devel}.rpm":
    ensure  => present,
    source  => "${alternate_url}/${package_name_devel}.rpm",
    extract => false,
    creates => "${destination_devel}.rpm",
    cleanup => false,
  }

  # install basic package
  package { $package_name_basic:
    ensure          => 'installed',
    provider        => $package_provider,
    source          => "${destination_basic}.rpm",
    install_options => '--force',
    require         => Archive["${destination_basic}.rpm"],
  }

  # install devel package
  package { $package_name_devel:
    ensure          => 'installed',
    provider        => $package_provider,
    source          => "${destination_devel}.rpm",
    install_options => '--force',
    require         => Archive["${destination_devel}.rpm"],
  }

}
