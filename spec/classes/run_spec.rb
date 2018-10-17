require 'spec_helper'

describe 'php_oci8' do
  let(:facts) do
  {
    'os' => {
      'family'       => 'RedHat',
    },
    'osfamily'   => 'RedHat',
    'kernel' => 'Linux',
    'env_temp_variable' => '/tmp'
  }
end
  context 'on redhat-6-x86_64' do
    let(:facts) do
      super().merge(
        'os' => {
          'architecture' => 'x86_64',
          'release'      => {
            'major' => '6',
          },
        },
      )
    end

    context 'php_oci8 class without any parameters' do
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('php_oci8::install').that_comes_before('php_oci8::config') }
      it { is_expected.to contain_class('php_oci8::config') }
    end
  end
end
