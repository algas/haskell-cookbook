#
# Author:: Masahiro Yamauchi (<sgt.yamauchi@gmail.com>)
# Cookbook Name:: haskell
# Recipe:: ghc-binary
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

if node['haskell']['ghc']['packages'].length == 0
  packages = value_for_platform(
    "ubuntu" => {
      "13.04" => ["build-essential","libgmp-dev","libgmp3-dev"],
      "14.04" => ["build-essential","libgmp-dev","libgmp3-dev"],
      "default" => ["build-essential","libgmp-dev","libgmp3-dev","libgmp3c2"],
    }
  )
else
  packages = node['haskell']['ghc']['packages']
end

packages.each do |pkg|
  package pkg do
    action :install
  end
end

version = node['haskell']['ghc']['version']
configure_options = node['haskell']['ghc']['configure_options'].join(" ")
archive_file = node['haskell']['ghc']['archive_file']
cache_dir = node['haskell']['ghc']['cache_dir']

directory node['haskell']['ghc']['cache_dir'] do
  owner node['haskell']['ghc']['owner']
  group node['haskell']['ghc']['group']
  mode "0755"
  action :create
  not_if { ::File.exists?(node['haskell']['ghc']['cache_dir']) }
end

directory node['haskell']['ghc']['prefix_dir'] do
  owner node['haskell']['ghc']['owner']
  group node['haskell']['ghc']['group']
  mode "0755"
  action :create
  not_if { ::File.exists?(node['haskell']['ghc']['prefix_dir']) }
end

remote_file File.join(cache_dir, archive_file) do
  source node['haskell']['ghc']['download']
  owner node['haskell']['ghc']['owner']
  group node['haskell']['ghc']['group']
  mode "0644"
  not_if { ::File.exists?(File.join(cache_dir, archive_file)) }
end

bash "build-and-install-ghc" do
  cwd cache_dir
  user node['haskell']['ghc']['owner']
  group node['haskell']['ghc']['group']
  code <<-EOF
    (tar -xvf #{archive_file} && cd ghc-#{version} && ./configure #{configure_options} && make install)
  EOF
  not_if { ::File.exists?(node['haskell']['ghc']['binary']) }
end

