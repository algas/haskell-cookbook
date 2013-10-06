#
# Author:: Masahiro Yamauchi (<sgt.yamauchi@gmail.com>)
# Cookbook Name:: haskell
# Attribute:: default['haskell']
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

## common attributes
default['haskell']['owner'] = 'deploy'
default['haskell']['group'] = 'app'

## ghc attributes
default['haskell']['ghc']['install_method'] = 'package'
default['haskell']['ghc']['prefix_dir'] = '/usr/local'
default['haskell']['ghc']['cache_dir'] = Chef::Config[:file_cache_path]
default['haskell']['ghc']['packages'] = []

default['haskell']['ghc']['binary'] = "#{haskell['ghc']['prefix_dir']}/bin/ghc"
default['haskell']['ghc']['url'] = 'http://www.haskell.org/ghc/dist'
default['haskell']['ghc']['version'] = '7.6.3'
default['haskell']['ghc']['archive_file'] = "ghc-#{haskell['ghc']['version']}-x86_64-unknown-linux.tar.bz2"
default['haskell']['ghc']['download'] = "#{haskell['ghc']['url']}/#{haskell['ghc']['version']}/#{haskell['ghc']['archive_file']}"
default['haskell']['ghc']['configure_options'] = %W{--prefix=#{haskell['ghc']['prefix_dir']}}
default['haskell']['ghc']['owner'] = haskell['owner']
default['haskell']['ghc']['group'] = haskell['group']

## cabal attributes
default['haskell']['cabal']['install_method'] = 'package'
default['haskell']['cabal']['packages'] = []

default['haskell']['cabal']['cache_dir'] = Chef::Config[:file_cache_path]
default['haskell']['cabal']['prefix_dir'] = "#{ENV['HOME']}/.cabal"
default['haskell']['cabal']['binary'] = "#{haskell['cabal']['prefix_dir']}/bin/cabal"
default['haskell']['cabal']['ghc_dir'] = haskell['ghc']['prefix_dir']
default['haskell']['cabal']['ghc'] = "#{haskell['cabal']['ghc_dir']}/bin/ghc"
default['haskell']['cabal']['ghc_pkg'] = "#{haskell['cabal']['ghc_dir']}/bin/ghc-pkg"
default['haskell']['cabal']['extra_opts'] = "--package-db=#{haskell['cabal']['ghc_dir']}/lib/ghc-#{haskell['ghc']['version']}/package.conf.d"
default['haskell']['cabal']['url'] = 'http://hackage.haskell.org/package'
default['haskell']['cabal']['version'] = '1.18.0.2'
default['haskell']['cabal']['archive_file'] = "cabal-install-#{haskell['cabal']['version']}.tar.gz"
default['haskell']['cabal']['download'] = "#{haskell['cabal']['url']}/cabal-install-#{haskell['cabal']['version']}/#{haskell['cabal']['archive_file']}"
default['haskell']['cabal']['configure_options'] = "PREFIX=#{haskell['cabal']['prefix_dir']} GHC=#{haskell['cabal']['ghc']} GHC_PKG=#{haskell['cabal']['ghc_pkg']} EXTRA_CONFIGURE_OPTS=#{haskell['cabal']['extra_opts']}"
default['haskell']['cabal']['scope'] = '--user'
default['haskell']['cabal']['extract_command'] = 'tar'
default['haskell']['cabal']['extract_options'] = '-xvf'
default['haskell']['cabal']['cabal_dir'] = "cabal-install-#{haskell['cabal']['version']}"
default['haskell']['cabal']['owner'] = haskell['owner']
default['haskell']['cabal']['group'] = haskell['group']
