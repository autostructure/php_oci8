# == Class php_oci8::service
#
# Author: Paul Talbot, Autostructure
#
# ===============================================
#
# ===============================================
#
# @summary
#   Called by init (after config class) to restart php-fpm for PHP on Linux
#

class php_oci8::service {

  service { 'php-fpm':
    ensure  => 'running',
    enable  => true,
    require => Class['php'],
  }

}
