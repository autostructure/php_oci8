# Class: php_oci8
# ===========================
#
# Full description of class php_oci8 here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class php_oci8 (
  $package_prefix    = $::php_oci8::params::package_prefix,
  $major             = $::php_oci8::params::major,
  $minor             = $::php_oci8::params::minor,
  $version           = $::php_oci8::params::version,
  $architecture      = $::php_oci8::params::architecture,
  $temp_location     = $::php_oci8::params::temp_location,
  $pecl_oci8_version = $::php_oci8::params::pecl_oci8_version,
) inherits ::php_oci8::params {

  # validate parameters here
  validate_string($package_prefix)
  validate_string($major)
  validate_string($minor)
  validate_string($version)
  validate_string($architecture)
  validate_string($temp_location)
  validate_string($pecl_oci8_version)

  class { '::php_oci8::install': } ->
  class { '::php_oci8::config': } -> #~>
  #class { '::php_oci8::service': } ->
  Class['::php_oci8']
}
