# == Class php_oci8
#
# Author: Paul Talbot, Autostructure
#
# ===============================================
#
# @summary
#   Installs and configures Oracle OCI8 for PHP on Linux
#
# @example Basic usage in respective profile(s)
#   class { '::php_oci8':
#     package_prefix        => $package_prefix,
#     instantclient_major   => $major,
#     instantclient_minor   => $minor,
#     instantclient_version => $version,
#     instantclient_source  => $source,
#     architecture          => $architecture,
#     temp_location         => $temp_location,
#     pecl_oci8_version     => $pecl_oci8_version,
#   }
#
# @param package_prefix
#   Specifies PHP package prefix for PHP devel dependency in php_oci8::install class.
#   Required - e.g. 'php-'
#
# @param alternate_url
#   Base URL for alternate installer location
#   Defaults to 'undef'
#
# @param oracle_url
#   Base URL for Oracle's installer
#   Defaults to 'http://download.oracle.com/otn/linux/instantclient/'
#
# @param instantclient_source
#   Where to install package(s) from.
#   Defaults to 'oracle_website'
#
# @param instantclient_major
#   OCI8 package major version.
#   Required - e.g. '12'
#
# @param instantclient_minor
#   OCI8 package minor version.
#   Required - e.g. '1'
#
# @param instantclient_patch_a
#   OCI8 package patch version (a).
#   Required - e.g. '1'
#
# @param instantclient_patch_b
#   OCI8 package patch version (b).
#   Required - e.g. '1'
#
# @param instantclient_patch_c
#   OCI8 package patch version (c).
#   Required - e.g. '1'
#
# @param instantclient_version
#   Full OCI8 package version number.
#   Required - e.g. '12.1.0.2.0'
#
# @param instantclient_product
#   OCI8 product name according to Oracle.
#   Defaults to 'oracle-instantclient'
#
# @param architecture
#   Architecture of processor implemented.
#   Defaults to $::facts['architecture'] - e.g. 'x86_64'
#
# @param temp_location
#   Defaults to $::facts['env_temp_variable'] - e.g. '/tmp'
#
# @param pecl_oci8_version
#   PECL extension for Oracle version number.
#   Required - e.g. '2.0.12'
#

class php_oci8 (
  String $package_prefix,
  Integer $instantclient_major,
  Integer $instantclient_minor,
  Integer $instantclient_patch_a,
  Integer $instantclient_patch_b,
  Integer $instantclient_patch_c,
  String $instantclient_product_name,
  String $pecl_oci8_version,
  Boolean $instantclient_use_package_manager,
  String $oracle_url,
  String $oracle_url_proxy_server,
  String $oracle_url_proxy_type,
  String $alternate_package_name,
  String $alternate_url,
  ) {

  class {'::php_oci8::install':}
  -> Class { '::php_oci8::config': }
  -> Class['::php_oci8']

}
