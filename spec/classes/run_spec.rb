require 'spec_helper'

describe 'php_oci8' do
  let(:facts) do
    {
      'kernel'              => 'Linux',
      'where_is_temp'       => '/tmp',
      'osfamily'            => 'RedHat',
      'pecl_oci8_extension' => {
        'version' => {
          'full' => '2.0.7',
        },
      },
    }
  end

  context 'on redhat-6-x86_64' do
    let(:facts) do
      super().merge(
        'os' => {
          'architecture' => 'x86_64',
          'family'       => 'RedHat',
          'release'      => {
            'major' => '6',
          },
        },
        'operatingsystem'           => 'RedHat',
        'operatingsystemrelease'    => '6.10',
        'operatingsystemmajrelease' => '6',
      )
    end

    context 'php_oci8 class without any parameters' do
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('php_oci8::install') }
      it { is_expected.to contain_class('php_oci8::config') }

      describe 'php_oci8::install' do
        it { is_expected.to contain_class('php') }
        it { is_expected.to contain_class('php_oci8::install::oracle_website') }
        it { is_expected.to contain_class('archive') }
        it { is_expected.to contain_file('/tmp/answers-pecl-oci8-18.3.txt') }
      end

      describe 'php_oci8::config' do
        it { is_expected.to contain_file('add-oci8-extension').with_owner('root') }
        it { is_expected.to contain_file('add-oci8-extension').with_group('root') }
        it { is_expected.to contain_file('add-oci8-extension').with_mode('0644') }
        it { is_expected.to contain_file('add-oci8-extension').with('content' => %r{^extension=oci8.so\n}) }
      end
    end

    context 'php_oci8 class with instantclient_use_package_manager' do
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('php_oci8::install') }
      it { is_expected.to contain_class('php_oci8::config') }

      describe 'php_oci8::install' do
        let(:params) do
          {
            instantclient_use_package_manager: true,
            alternate_package_name_basic: 'oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64',
            alternate_package_name_devel: 'oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64',
          }
        end

        it { is_expected.to contain_class('php') }
        it { is_expected.to contain_class('php_oci8::install::package_manager') }
      end

      describe 'php_oci8::config' do
        let(:params) do
          {
            pecl_oci8_version: '2.0.7',
          }
        end

        it { is_expected.to contain_file('add-oci8-extension').with_owner('root') }
        it { is_expected.to contain_file('add-oci8-extension').with_group('root') }
        it { is_expected.to contain_file('add-oci8-extension').with_mode('0644') }
        it { is_expected.to contain_file('add-oci8-extension').with('content' => %r{^extension=oci8.so\n}) }
      end
    end

    context 'php_oci8 class with alternate_url' do
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('php_oci8::install') }
      it { is_expected.to contain_class('php_oci8::config') }

      describe 'php_oci8::install' do
        let(:params) do
          {
            alternate_url: 'http://download.oracle.com/otn/linux/instantclient/',
            alternate_package_name_basic: 'oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64',
            alternate_package_name_devel: 'oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64',
          }
        end

        it { is_expected.to contain_class('php') }
        it { is_expected.to contain_class('php_oci8::install::alternate_url') }
        it { is_expected.to contain_class('archive') }
      end

      describe 'php_oci8::config' do\
        let(:params) do
          {
            pecl_oci8_version: '2.0.7',
          }
        end

        it { is_expected.to contain_file('add-oci8-extension').with_owner('root') }
        it { is_expected.to contain_file('add-oci8-extension').with_group('root') }
        it { is_expected.to contain_file('add-oci8-extension').with_mode('0644') }
        it { is_expected.to contain_file('add-oci8-extension').with('content' => %r{^extension=oci8.so\n}) }
      end
    end
  end

  context 'on redhat-7-x86_64' do
    let(:facts) do
      super().merge(
        'os' => {
          'architecture' => 'x86_64',
          'family'       => 'RedHat',
          'release'      => {
            'major' => '7',
          },
        },
        'operatingsystem'           => 'RedHat',
        'operatingsystemrelease'    => '7.5',
        'operatingsystemmajrelease' => '7',
      )
    end

    context 'php_oci8 class without any parameters' do
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('php_oci8::install') }
      it { is_expected.to contain_class('php_oci8::config') }

      describe 'php_oci8::install' do
        it { is_expected.to contain_class('php') }
        it { is_expected.to contain_class('php_oci8::install::oracle_website') }
        it { is_expected.to contain_class('archive') }
        it { is_expected.to contain_file('/tmp/answers-pecl-oci8-18.3.txt') }
      end

      describe 'php_oci8::config' do
        let(:params) do
          {
            pecl_oci8_version: '2.0.7',
          }
        end

        it { is_expected.to contain_file('add-oci8-extension').with_owner('root') }
        it { is_expected.to contain_file('add-oci8-extension').with_group('root') }
        it { is_expected.to contain_file('add-oci8-extension').with_mode('0644') }
        it { is_expected.to contain_file('add-oci8-extension').with('content' => %r{^extension=oci8.so\n}) }
      end
    end

    context 'php_oci8 class with instantclient_use_package_manager' do
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('php_oci8::install') }
      it { is_expected.to contain_class('php_oci8::config') }

      describe 'php_oci8::install' do
        let(:params) do
          {
            instantclient_use_package_manager: true,
            alternate_package_name_basic: 'oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64',
            alternate_package_name_devel: 'oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64',
          }
        end

        it { is_expected.to contain_class('php') }
        it { is_expected.to contain_class('php_oci8::install::package_manager') }
      end

      describe 'php_oci8::config' do
        let(:params) do
          {
            pecl_oci8_version: '2.0.7',
          }
        end

        it { is_expected.to contain_file('add-oci8-extension').with_owner('root') }
        it { is_expected.to contain_file('add-oci8-extension').with_group('root') }
        it { is_expected.to contain_file('add-oci8-extension').with_mode('0644') }
        it { is_expected.to contain_file('add-oci8-extension').with('content' => %r{^extension=oci8.so\n}) }
      end
    end

    context 'php_oci8 class with alternate_url' do
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('php_oci8::install') }
      it { is_expected.to contain_class('php_oci8::config') }

      describe 'php_oci8::install' do
        let(:params) do
          {
            alternate_url: 'http://download.oracle.com/otn/linux/instantclient/',
            alternate_package_name_basic: 'oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64',
            alternate_package_name_devel: 'oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64',
          }
        end

        it { is_expected.to contain_class('php') }
        it { is_expected.to contain_class('php_oci8::install::alternate_url') }
        it { is_expected.to contain_class('archive') }
      end

      describe 'php_oci8::config' do
        let(:params) do
          {
            pecl_oci8_version: '2.0.7',
          }
        end

        it { is_expected.to contain_file('add-oci8-extension').with_owner('root') }
        it { is_expected.to contain_file('add-oci8-extension').with_group('root') }
        it { is_expected.to contain_file('add-oci8-extension').with_mode('0644') }
        it { is_expected.to contain_file('add-oci8-extension').with('content' => %r{^extension=oci8.so\n}) }
      end
    end
  end
end
