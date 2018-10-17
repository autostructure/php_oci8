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

  $package_name_basic = $::php_oci8::alternate_package_name_basic
  $package_name_devel = $::php_oci8::alternate_package_name_devel

  if ($package_name_basic) and ($package_name_devel) {
    package { $package_name_basic:
      ensure   => 'installed',
    }
    package { $package_name_devel:
      ensure   => 'installed',
    }
  }
  else {
    # alternate package names are required if using a package manager like yum or apt
    fail('Package manager "true" but alternate package name(s) not set.')
  }
}
