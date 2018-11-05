require 'spec_helper_acceptance'

describe 'php_oci8 class' do
#  context 'default parameters' do
#    # Using puppet_apply as a helper
#    it 'works idempotently with no errors' do
#      pp = <<-EOS
#      class { 'php_oci8': }
#      EOS
#
#      # Run it twice and test for idempotency
#      apply_manifest(pp, catch_failures: true)
#      apply_manifest(pp, catch_changes: true)
#    end
#
#
#
#    # File[/etc/php-fpm.d/www.conf]
#    # File[/etc/php-fpm.d/www.conf]/mode: mode changed '0644' to '0640'
#  end

  context 'parameters for alternate_url install' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'php_oci8':
        alternate_package_name_basic => 'oracle-instantclient18.3-basic-18.3.0.0.0-1.x86_64',
        alternate_package_name_devel => 'oracle-instantclient18.3-devel-18.3.0.0.0-1.x86_64',
        alternate_url                => 'http://ptalbot.freeshell.org/oracle-instantclient',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    #    # File[/etc/php-fpm.d/www.conf]
    #    # File[/etc/php-fpm.d/www.conf]/mode: mode changed '0644' to '0640'

    describe file('/etc/php-fpm.d/www.conf') do
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end

    describe file('/var/run/php-fpm') do
      it { is_expected.to be_owned_by 'apache' }
      it { is_expected.to be_grouped_into 'apache' }
    end

    describe file('/etc/php-fpm.conf') do
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end

    describe service('php-fpm') do
      it { is_expected.to be_running }
    end

    describe package('gcc') do
      it { is_expected.to be_installed }
    end

    describe package('php-cli') do
      it { is_expected.to be_installed }
    end

    describe package('php-xml') do
      it { is_expected.to be_installed }
    end

    describe package('php-common') do
      it { is_expected.to be_installed }
    end

    describe package('php-process') do
      it { is_expected.to be_installed }
    end

    describe package('php-pear') do
      it { is_expected.to be_installed }
    end

    describe package('php-devel') do
      it { is_expected.to be_installed }
    end

    describe package('oracle-instantclient18.3-basic-18.3.0.0.0-1.x86_64') do
      it { is_expected.to be_installed }
    end

    describe package('oracle-instantclient18.3-basic-18.3.0.0.0-1.x86_64') do
      it { is_expected.to be_installed }
    end

  end
end
