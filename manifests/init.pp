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
  String $major             = $::php_oci8::params::major,
  String $minor             = $::php_oci8::params::minor,
  String $version           = $::php_oci8::params::version,
  String $architecture      = $::php_oci8::params::architecture,
  String $temp_location     = $::php_oci8::params::temp_location,
  String $pecl_oci8_version = $::php_oci8::params::pecl_oci8_version,
) inherits ::php_oci8::params {

  # validate parameters here

  class { '::php_oci8::install': } ->
  class { '::php_oci8::config': } -> #~>
  #class { '::php_oci8::service': } ->
  Class['::php_oci8']
}
