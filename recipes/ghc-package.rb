#
# Author:: Masahiro Yamauchi (<sgt.yamauchi@gmail.com>)
# Cookbook Name:: haskell
# Recipe:: ghc-package
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

major_version = node['haskell']['ghc']['version'].split('.').first.to_i

if major_version == 7
  ghc_packages = value_for_platform(
    "default" => ["ghc"]
  )
else
  ghc_packages = value_for_platform(
    "default" => ["ghc6"]        
  )
end

ghc_packages.each do |pkg|
  package pkg do
    action :install
  end
end


