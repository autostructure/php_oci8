# == Class php_oci8::install
#
# This class is called from php_oci8 for install.
#
class php_oci8::install {

  $file_base_location = "${::php_oci8::temp_location}/oracle-instantclient${::php_oci8::major}.${::php_oci8::minor}"

  file {"${file_base_location}-basic-${::php_oci8::version}-1.${::php_oci8::architecture}.rpm":
    source => "puppet:///modules/php_oci8/oracle-instantclient${::php_oci8::major}.${::php_oci8::minor}-basic-${::php_oci8::version}-1.${::php_oci8::architecture}.rpm",
  }

  file {"${file_base_location}-devel-${::php_oci8::version}-1.${::php_oci8::architecture}.rpm":
    source => "puppet:///modules/php_oci8/oracle-instantclient${::php_oci8::major}.${::php_oci8::minor}-devel-${::php_oci8::version}-1.${::php_oci8::architecture}.rpm",
  }

  file {"answer-pecl-oci8-${file_base_location}.txt":
    source => "puppet:///modules/php_oci8/answer-pecl-oci8-${file_base_location}.txt",
  }

  package {'oracle-instantclient-basic':
    ensure          => installed,
    name            => "oracle-instantclient${::php_oci8::major}.${::php_oci8::minor}-basic-${::php_oci8::version}-1.${::php_oci8::architecture}.rpm",
    provider        => 'rpm',
    source          => "${file_base_location}-basic-${::php_oci8::version}-1.${::php_oci8::architecture}.rpm",
    install_options => '--force',
    require         => File["${file_base_location}-basic-${::php_oci8::version}-1.${::php_oci8::architecture}.rpm"],
  }

  package {'oracle-instantclient-devel':
    ensure          => installed,
    name            => "oracle-instantclient${::php_oci8::major}.${::php_oci8::minor}-devel-${::php_oci8::version}-1.${::php_oci8::architecture}.rpm",
    provider        => 'rpm',
    source          => "${file_base_location}-devel-${::php_oci8::version}-1.${::php_oci8::architecture}.rpm",
    install_options => '--force',
    require         => [ File["${file_base_location}-devel-${::php_oci8::version}-1.${::php_oci8::architecture}.rpm"], Package['oracle-instantclient-basic']],
  }

  package {'php-devel':
    ensure  => installed,
    require => Class['php'];
  }

}
