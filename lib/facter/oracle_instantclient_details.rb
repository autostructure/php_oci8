# frozen_string_literal: true

require 'facter'
require 'puppet'
require 'rubygems'
require 'pp'

regex = '/instantclient/'

packages = {}
all_packages = Puppet::Type.type(:package).instances

def get_yum_version(package_name, package_version)
  result = Facter::Core::Execution.exec("/bin/rpm -q --queryformat \"%{NAME} %{VERSION}\" | grep #{partial_name}")
  result
end

def generate_output(package_name, package_version)
  packages = {}
  packages[:name] = package_name
  packages[:version] = package_version
end

all_packages.each do |regex|
  matching_packages = all_packages.select { |resource| resource.name =~ %r{#{regex}} }
  matching_packages.each do |matching_package|
    get_yum_version(matching_package[:name], matching_package[:version])
    generate_output(matching_package, installed_version)
  end
  # pp packages
  Facter.add(:packages_of_interest) do
    confine kernel: 'Linux'
    setcode do
      packages
    end
  end
end
