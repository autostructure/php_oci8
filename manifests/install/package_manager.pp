# == Class php_oci8::install::package_manager
#
# Author: Paul Talbot, Autostructure
#
# ===============================================
#
# ===============================================
#
# @summary
#   Called by php_oci8::install class to install using package manager
#

class php_oci8::install::package_manager {

  $package_name_basic = $::php_oci8::alternate_basic_package_name
  $package_name_devel = $::php_oci8::alternate_devel_package_name

  if ($package_name_basic == '') or ($package_name_devel == '') {
    # alternate package names are required if using a package manager like yum or apt
    fail('Package manager "true" but alternate package name(s) not set.')
  }
  else {
    package { $package_name_basic:
      ensure   => 'installed',
    }
    package { $package_name_devel:
      ensure   => 'installed',
    }
  }
}
