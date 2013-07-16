#
# Author:: Masahiro Yamauchi (<sgt.yamauchi@gmail.com>)
# Cookbook Name:: haskell
# Recipe:: cabal-source
#
# Copyright 2013, Masahiro Yamauchi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if node['haskell']['cabal']['packages'].length == 0
  packages = value_for_platform(
    "ubuntu" => {
      "default" => ['zlib1g-dev'],
    }
  )
else
  packages = node['haskell']['cabal']['packages']
end

packages.each do |pkg|
  package pkg do
    action :install
  end
end

extract_command = node['haskell']['cabal']['extract_command']
extract_options = node['haskell']['cabal']['extract_options']
configure_options = node['haskell']['cabal']['configure_options']
archive_file = node['haskell']['cabal']['archive_file']
cabal_dir = node['haskell']['cabal']['cabal_dir']
cache_dir = node['haskell']['cabal']['cache_dir']
scope = node['haskell']['cabal']['scope']

directory cache_dir do
  owner node['haskell']['cabal']['owner']
  group node['haskell']['cabal']['group']
  action :create
  not_if { ::File.exists?(cache_dir) }
end

remote_file "#{File.join(cache_dir, archive_file)}" do
  source node['haskell']['cabal']['download']
  owner node['haskell']['cabal']['owner']
  group node['haskell']['cabal']['group']
  mode "0644"
  not_if { ::File.exists?("#{File.join(cache_dir, archive_file)}") }
end

bash "build-and-install-cabal-install" do
  cwd cache_dir
  user node['haskell']['cabal']['owner']
  group node['haskell']['cabal']['group']
  code <<-EOF
    (#{extract_command} #{extract_options} #{archive_file} && cd #{cabal_dir} && #{configure_options} bash bootstrap.sh #{scope})
  EOF
  not_if { ::File.exists?(node['haskell']['cabal']['binary']) }
end

