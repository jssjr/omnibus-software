#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# License:: Apache License, Version 2.0
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

name "gecode"
version "3.7.1"

source :url => "http://www.gecode.org/download/gecode-3.7.1.tar.gz",
       :md5 => "b4191d8cfafa18bd9b78594544be2a04"

relative_path "gecode-3.7.1"

test = Mixlib::ShellOut.new("test -f /usr/bin/gcc44")
test.run_command

configure_env = if test.exitstatus == 0
                  {"CC" => "gcc44", "CXX" => "g++44"}
                else
                  {}
                end

gmake =
  case platform
  when "freebsd"
    "gmake"
  else
    "make"
  end

build do
  command(["./configure",
           "--prefix=#{install_dir}/embedded",
           "--disable-doc-dot",
           "--disable-doc-search",
           "--disable-doc-tagfile",
           "--disable-doc-chm",
           "--disable-doc-docset",
           "--disable-qt",
           "--disable-examples"].join(" "),
          :env => configure_env)
  command "#{gmake} -j #{max_build_jobs}", :env => { "LD_RUN_PATH" => "#{install_dir}/embedded/lib" }
  command "#{gmake} install"
end
