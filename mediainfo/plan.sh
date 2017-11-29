pkg_name=mediainfo
pkg_origin=ncerny
pkg_version="17.10"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=('BSD')
pkg_source="https://mediaarea.net/download/binary/${pkg_name}/${pkg_version}/MediaInfo_CLI_${pkg_version}_GNU_FromSource.tar.xz"
pkg_shasum="74a36eb51b4ba3e53d238825827e8e7532011296a4b3987b1c75cf87704f51a0"
pkg_dirname="MediaInfo_CLI_GNU_FromSource"

pkg_description="MediaInfo is a convenient unified display of the most relevant technical and tag data for video and audio files.
Copyright (c) 2002-2017 MediaArea.net SARL<mailto:info@mediaarea.net>. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Project License: https://mediaarea.net/en/MediaInfo/License
"
pkg_upstream_url="https://mediaarea.net/en/MediaInfo"

pkg_deps=(core/glibc core/zlib)
pkg_build_deps=(core/automake core/autoconf core/make core/gcc core/libtool core/pkg-config)
# pkg_lib_dirs=(lib)
# pkg_include_dirs=(include)
# pkg_bin_dirs=(bin)
# pkg_pconfig_dirs=(lib/pconfig)
# pkg_svc_run="bin/haproxy -f $pkg_svc_config_path/haproxy.conf"
# pkg_exports=(
#   [host]=srv.address
#   [port]=srv.port
#   [ssl-port]=srv.ssl.port
# )
# pkg_exposes=(port ssl-port)
# pkg_binds=(
#   [database]="port host"
# )
# pkg_binds_optional=(
#   [storage]="port host"
# )
# pkg_interpreters=(bin/bash)
# pkg_svc_user="hab"
# pkg_svc_group="$pkg_svc_user"
# pkg_description="Some description."
# Below is the default behavior for this callback. Anything you put in this
# callback will override this behavior. If you want to use default behavior
# delete this callback from your plan.
# @see https://www.habitat.sh/docs/reference/plan-syntax/#callbacks
# @see https://github.com/habitat-sh/habitat/blob/master/components/plan-build/bin/hab-plan-build.sh
do_build() {
  cd ZenLib/Project/GNU/Library/
  ./configure --prefix=$pkg_prefix --enable-static --disable-shared $*
  make clean
  make -s -j8
  cd ../../../../MediaInfoLib/Project/GNU/Library/
  ./configure --prefix=$pkg_prefix --enable-static --disable-shared $*
  make clean
  make -s -j8
  cd ../../../../MediaInfo/Project/GNU/CLI/
  ./configure --prefix=$pkg_prefix --enable-staticlibs $*
  make clean
  make -s -j8
  return $?
}

# Below is the default behavior for this callback. Anything you put in this
# callback will override this behavior. If you want to use default behavior
# delete this callback from your plan.
# @see https://www.habitat.sh/docs/reference/plan-syntax/#callbacks
# @see https://github.com/habitat-sh/habitat/blob/master/components/plan-build/bin/hab-plan-build.sh
do_install() {
    cd MediaInfo/Project/GNU/CLI && make install
    return $?
}
# There is no default implementation of this callback. This is called after
# the package has been built and installed. You can use this callback to
# remove any temporary files or perform other post-install clean-up actions.
# @see https://www.habitat.sh/docs/reference/plan-syntax/#callbacks
# @see https://github.com/habitat-sh/habitat/blob/master/components/plan-build/bin/hab-plan-build.sh
do_end() {
    cp ${HAB_CACHE_SRC_PATH}/${pkg_dirname}/MediaInfo/LICENSE $pkg_prefix
}
