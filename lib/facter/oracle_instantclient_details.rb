# frozen_string_literal: true

require 'facter'
require 'puppet'
require 'rubygems'
require 'pp'

# oracle_instantclient_packages hash is "target group" key with corresponding regex value
oracle_instantclient_packages = { 'instantclient' => '^oracle-instantclient' }
packages = {}
versions = {}
all_packages = Puppet::Type.type(:package).instances

def get_apt_version(package_name)
  result = Facter::Core::Execution.exec("/usr/bin/dpkg-query --showformat='${Version}' --show #{package_name}")
  result
end

def get_gem_version(gem_name)
  specs = Gem::Specification.find_by_name(gem_name)
  # Gem::Specification.reset
  specs.version
end

def get_yum_version(package_name)
  result = Facter::Core::Execution.exec("/bin/rpm -q --queryformat \"%{VERSION}\" #{package_name}")
  result
end

def generate_output(target_group, matching_package, version, packages)
  package = {}
  package[:target_group] = target_group
  package[:version] = version
  package[:provider] = matching_package[:provider].to_s
  packages[matching_package[:name]] = package
end

oracle_instantclient_packages.each do |target_group, regex|
  matching_packages = all_packages.select { |resource| resource.name =~ %r{#{regex}} }
  matching_packages.each do |matching_package|
    case matching_package[:provider].to_s
    when 'apt' ####################
      version = get_apt_version(matching_package[:name])
      versions = version
      generate_output(target_group, matching_package, version, packages)
    when 'gem' ####################
      version = get_gem_version(matching_package[:name]).to_s
      versions = version
      generate_output(target_group, matching_package, version, packages)
    when 'yum' ####################
      version = get_yum_version(matching_package[:name])
      versions = version
      generate_output(target_group, matching_package, version, packages)
    else
      puts "unknown provider passed (#{package[:provider]})"
    end
  end

  # pp packages
  Facter.add(:oracle_instantclient_packages) do
    confine kernel: 'Linux'
    setcode do
      packages
    end
  end

  Facter.add(:oracle_instantclient_versions) do
    confine kernel: 'Linux'
    setcode do
      versions
    end
  end
end
