# == Class php_oci8::service
#
# This class is meant to be called from php_oci8.
# It ensure the service is running.
#
class php_oci8::service {

  service { $::php_oci8::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
