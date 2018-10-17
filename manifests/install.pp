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

  $temp_location = $::facts['env_temp_variable']

  if $::php_oci8::instantclient_use_package_manager == true {
    #
    # custom package install using package manager ##################
    #
    include php_oci8::install::package_manager
  }
  elsif $::php_oci8::alternate_url {
    #
    # install using non-Oracle URL from hiera #######################
    #
    include php_oci8::install::alternate_url
  }
  else {
    #
    # install using Oracle's URL from hiera #########################
    #
    include php_oci8::install::oracle_website
  }

  file {"${temp_location}/answers-pecl-oci8-${::php_oci8::instantclient_major}.${::php_oci8::instantclient_minor}.txt":
    ensure => present,
    #replace => 'no',
    source => "puppet:///modules/php_oci8/answers-pecl-oci8-${::php_oci8::instantclient_major}.${::php_oci8::instantclient_minor}.txt",
  }

  #package {"${::php_oci8::package_prefix}devel":
  #  ensure  => 'installed',
  #  name    => '',
  #  require => Class['php'],
  #  #before  => Exec['pecl-install-oci8'],
  #}

}
