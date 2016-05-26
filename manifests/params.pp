# == Class php_oci8::params
#
# This class is meant to be called from php_oci8.
# It sets variables according to platform.
#
class php_oci8::params {
  $major = '12'
  $minor = '1'
  $version = '12.1.0.2.0'
  $architecture = 'x86_64'
  $temp_location = '/tmp'
  $pecl_oci8_version = '2.0.7'
}
