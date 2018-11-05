# == Class php_oci8::install
#
# Author: Paul Talbot, Autostructure
#
# ===============================================
#
# ===============================================
#
# @summary
#   Called by init to install Oracle OCI8 for PHP on Linux
#

class php_oci8::install {

  # PHP required for devel package
  include ::php

  $temp_location = $::facts['where_is_temp']

  if $::php_oci8::instantclient_use_package_manager == true {
    #
    # custom package install using package manager ##################
    #
    contain php_oci8::install::package_manager
  }
  elsif $::php_oci8::alternate_url {
    #
    # install using non-Oracle URL from hiera #######################
    #
    contain php_oci8::install::alternate_url
  }
  else {
    #
    # install using Oracle's URL from hiera #########################
    #
    #contain php_oci8::install::oracle_website
    fail('Unable to continue, no install class available. Exiting.')
  }

  file {"${temp_location}/answers-pecl-oci8-${::php_oci8::instantclient_major}.${::php_oci8::instantclient_minor}.txt":
    ensure => present,
    #replace => 'no',
    source => "puppet:///modules/php_oci8/answers-pecl-oci8-${::php_oci8::instantclient_major}.${::php_oci8::instantclient_minor}.txt",
  }

}
