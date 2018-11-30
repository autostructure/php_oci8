# == Class php_oci8
#
# Author: Paul Talbot, Autostructure
#
# ===============================================
# TODO: update pecl answers file content to be dynamic and NOT in a file from files
# TODO: Make hash of cookies work for downloading from Oracle website
# ===============================================
#
# @summary
#   Installs and configures Oracle OCI8 for PHP on Linux
#
# @example Basic usage in respective profile(s)
#   class { '::php_oci8':
#     pecl_oci8_extension   => $pecl_oci8_extension,
#     instantclient_major => $instantclient_major,
#     instantclient_minor => $instantclient_minor,
#   }
#
# @param pecl_oci8_extension
#   PECL extension for OCI8 version number
#   Required - defaults to '2.0.12' in hiera
#
# @param instantclient_major
#   Major version of Oracle instant client to be installed
#   Required - defaults to '18' in hiera
#
# @param instantclient_minor
#   Minor version of Oracle instant client
#   Required - defaults to '3' in hiera
#
# @param instantclient_patch_a
#   First patch level of Oracle insant instantclient
#   Required - defaults to '0' in hiera
#
# @param instantclient_patch_b
#   Second patch level of Oracle instantclient
#   Required - defaults to '0' in hiera
#
# @param instantclient_patch_c
#   Third patch level of Oracle instantclient
#   Required - defaults to '0' in hiera
#
# @param instantclient_product_name
#   OCI8 product name according to Oracle.
#   Required - defaults to 'oracle-instantclient' in hiera
#
# @param instantclient_use_package_manager
#   Should system's package manager be used to install instant client?
#   NOTE: when true, alternate package name parameters must be specified
#   Required - defaults to 'false' in hiera
#
# @param oracle_url
#   Base URL for Oracle's installer
#   Required - defaults to 'http://download.oracle.com/otn/linux/instantclient/' in hiera
#
# @param oracle_url_proxy_type
#   Type of proxy node requires to connect to Internet
#   Required - defaults to 'none' in hiera
#
# @param oracle_url_proxy_server
#   Proxy FQDN/address to use when accessing Oracle website
#   Optional - defaults to 'undef' in class
#
# @param alternate_package_name_basic
#   Package name for "basic" instant client when *not* using Oracle's oracle_website
#   Optional - e.g. 'oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64'
#
# @param alternate_package_name_devel
#   Package name for "devel" instant client when *not* using Oracle's oracle_website
#   Optional - e.g. 'oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64'
#
# @param alternate_url
#   Base URL for alternate installer location
#   NOTE: ignored when instantclient_use_package_manager is true
#   Optional - e.g. 'https://repository.my.tld/installers/oracle/instantclient/'
#

class php_oci8 (
  String $pecl_oci8_version,
  Integer $instantclient_major,
  Integer $instantclient_minor,
  Integer $instantclient_patch_a,
  Integer $instantclient_patch_b,
  Integer $instantclient_patch_c,
  String $instantclient_product_name,
  Boolean $instantclient_use_package_manager,
  String $oracle_url,
  Enum['none', 'ftp', 'http', 'https'] $oracle_url_proxy_type,
  Optional[String] $oracle_url_proxy_server,
  Optional[String] $alternate_package_name_basic,
  Optional[String] $alternate_package_name_devel,
  Optional[String] $alternate_url,
  ) {

  class {'::php_oci8::preinstall':}
  -> Class { '::php_oci8::uninstall': }
  -> Class { '::php_oci8::install': }
  ~> Class { '::php_oci8::config': }
  ~> Class { '::php_oci8::service': }
  -> Class['::php_oci8']

}
