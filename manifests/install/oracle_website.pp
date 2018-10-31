# == Class php_oci8::install:oracle_website
#
# Author: Paul Talbot, Autostructure
#
# ===============================================
#
# ===============================================
#
# @summary
#   Called by php_oci8::install class to install from default source
#

class php_oci8::install::oracle_website {

  # archive module is used to download packages
  include ::archive

  # this variable is used for storing installer binary for package resource
  $temp_location = $::facts['where_is_temp']
  file { $temp_location:
    ensure  => 'directory',
  }

  # if a proxy is required to reach Internet for Oracle website, values come from hiera
  $oracle_url_proxy_server = $::php_oci8::oracle_url_proxy_server
  $oracle_url_proxy_type = $::php_oci8::oracle_url_proxy_type

  # determine package provider for package resources below
  case $facts['kernel'] {
    'Linux' : {
      case $facts['os']['family'] {
        'RedHat', 'Amazon' : {
          $package_type = 'rpm'
        }
        default : {
          fail ("Unsupported OS family ${$facts['os']['family']}.") }
      }
    }
    default : {
      fail ( "Unsupported platform ${$facts['kernel']}." ) }
  }

  # architecture mapping for package name
  case $facts['os']['architecture'] {
    'i386' : {
      $arch = 'i386'
      $basic_name = 'basiclite'
      $devel_name = 'devellite'
    }
    'x86_64' : {
      $arch = 'x86_64'
      $basic_name = 'basic'
      $devel_name = 'devel'
    }
    'amd64' : {
      $arch = 'x86_64'
      $basic_name = 'basic'
      $devel_name = 'devel'
    }
    default : {
      fail ("Unsupported architecture ${$facts['os']['architecture']}.")
    }
  }

  # following package names are based on these examples:
  # http://download.oracle.com/otn/linux/instantclient/183000/oracle-instantclient18.3-basic-18.3.0.0.0-1.x86_64.rpm
  # http://download.oracle.com/otn/linux/instantclient/183000/oracle-instantclient18.3-basiclite-18.3.0.0.0-1.i386.rpm
  #
  case $package_type {
    'rpm' : {
      $package_name_basic = "${::php_oci8::instantclient_product_name}${::php_oci8::instantclient_major}.${::php_oci8::instantclient_minor}-${basic_name}-${::php_oci8::instantclient_major}.${::php_oci8::instantclient_minor}.${::php_oci8::instantclient_patch_a}.${::php_oci8::instantclient_patch_b}.${::php_oci8::instantclient_patch_c}-1.${arch}.${package_type}"
      $package_name_devel = "${::php_oci8::instantclient_product_name}${::php_oci8::instantclient_major}.${::php_oci8::instantclient_minor}-${devel_name}-${::php_oci8::instantclient_major}.${::php_oci8::instantclient_minor}.${::php_oci8::instantclient_patch_a}.${::php_oci8::instantclient_patch_b}.${::php_oci8::instantclient_patch_c}-1.${arch}.${package_type}"
    }
    default : {
      fail ("Unknown package type ${package_type}.")
    }
  }

  $source_basic = "${::php_oci8::oracle_url}/${::php_oci8::instantclient_major}${::php_oci8::instantclient_minor}${::php_oci8::instantclient_patch_a}${::php_oci8::instantclient_patch_b}${::php_oci8::instantclient_patch_c}/${package_name_basic}"
  $source_devel = "${::php_oci8::oracle_url}/${::php_oci8::instantclient_major}${::php_oci8::instantclient_minor}${::php_oci8::instantclient_patch_a}${::php_oci8::instantclient_patch_b}${::php_oci8::instantclient_patch_c}/${package_name_devel}"

  # full path(s) to the installers
  $destination_basic = "${temp_location}/${package_name_basic}"
  $destination_devel = "${temp_location}/${package_name_devel}"
  #notice ("Destination for basic is ${destination_basic}.")
  #notice ("Destination for devel is ${destination_devel}.")

$cookie = "${::php_oci8::instantclient_major}.${::php_oci8::instantclient_minor}" ? {
  '18.3'  => {
    gpw_e24           => 'https%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Ftopics%2Flinuxx86-64soft-092277.html',
    oraclelicense     => 'accept-ic_linuxx8664-cookie',
    testSessionCookie => 'Enabled',
    s_vi              => '[CS]v1|2DE861968507F55C-400001094002CCCE[CE]',
    s_sq              => '%5B%5BB%5D%5D',
    s_nr              => '1540408109310-New',
    rt                => '"nu=http%3A%2F%2Fdownload.oracle.com%2Fotn%2Flinux%2Finstantclient%2F183000%2Foracle-instantclient18.3-basic-18.3.0.0.0-1.x86_64.rpm&dm=oracle.com&si=cdc4505d-9942-4221-b93b-00a56980aae7&ss=1540406878572&sl=4&tt=14778&obo=0&sh=1540408085592%3D4%3A0%3A14778%2C1540407565336%3D3%3A0%3A10325%2C1540407544004%3D2%3A0%3A8905%2C1540406884059%3D1%3A0%3A5473&cl=1540408109307&bcn=%2F%2F36cc206a.akstat.io%2F"',
  },
  default => {},
}

  # notify { "Cookie: ${cookie}[testSessionCookie]": }

  # get basic package installer from URL
  archive { $destination_basic:
    ensure       => 'present',
    source       => $source_basic,
    cookie       => 'gpw_e24=https%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Ftopics%2Flinuxx86-64soft-092277.html; oraclelicense=accept-ic_linuxx8664-cookie',
    extract_path => $temp_location,
    cleanup      => false,
    creates      => $destination_basic,
    proxy_server => $oracle_url_proxy_server,
    proxy_type   => $oracle_url_proxy_type,
  }

  # get devel package installer from URL
  archive { $destination_devel:
    ensure       => 'present',
    source       => $source_devel,
    cookie       => 'gpw_e24=https%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Ftopics%2Flinuxx86-64soft-092277.html; oraclelicense=accept-ic_linuxx8664-cookie',
    extract_path => $temp_location,
    cleanup      => false,
    creates      => $destination_devel,
    proxy_server => $oracle_url_proxy_server,
    proxy_type   => $oracle_url_proxy_type,
  }

  # install basic package
  package { 'instantclient-basic':
    ensure          => 'installed',
    provider        => 'rpm',
    source          => $destination_basic,
    install_options => '--force',
    require         => Archive[$destination_basic],
  }

  # install devel package
  package { 'instantclient-development':
    ensure          => 'installed',
    provider        => 'rpm',
    source          => $destination_devel,
    install_options => '--force',
    require         => Archive[$destination_devel],
  }

}
