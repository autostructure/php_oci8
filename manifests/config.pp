# == Class php_oci8::config
#
# This class is called from php_oci8 for service config.
#

class php_oci8::config {

    exec {'pecl-install-oci8':
      command => "/bin/pecl install oci8 </tmp/answers-install-oci8-${::php_oci8::major}.${::php_oci8::minor}.txt",
      user    => root,
      timeout => 0,
      tries   => 5,
      unless  => '/usr/bin/php -m | grep -c oci8',
    }

    file_line {'add-oci8-php':
      path => '/etc/php.ini',
      line => 'extension=oci8.so',
    }

    file_line {'env-oracle':
      path   => '/etc/environment',
      line   => "\nexport ORACLE_HOME=/usr/lib/oracle/${::php_oci8::major}.${::php_oci8::minor}/client/lib\nexport NLS_DATE_FORMAT=\"DD/MM/YYYY HH24:MI\"",
      #notify => Service['httpd'],
    }

}
