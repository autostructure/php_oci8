# == Class php_oci8::preinstall
#
# Author: Paul Talbot, Autostructure
#
# ===============================================
#
# ===============================================
#
# @summary
#   Called by init to preinstall requirements for Oracle OCI8
#

class php_oci8::preinstall {
  package {'gcc':
    ensure => installed,
  }
}
