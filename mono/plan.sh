pkg_name=mono
pkg_origin=ncerny
pkg_version="5.4.0.201"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=('MIT')
pkg_source="https://download.mono-project.com/sources/${pkg_name}/${pkg_name}-${pkg_version}.tar.bz2"
# pkg_filename="${pkg_name}-${pkg_version}.tar.gz"
pkg_shasum="2a2f5c2a214a9980c086ac7561a5dd106f13d823a630de218eabafe1d995c5b4"
pkg_deps=(core/glibc)
pkg_build_deps=(core/make core/gcc core/autoconf core/automake core/coreutils core/bash core/libtool core/which core/cmake core/diffutils core/curl)
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_bin_dirs=(bin)
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
pkg_description="Mono is a software platform designed to allow developers to easily create cross platform applications. It is an open source implementation of Microsoft's .NET Framework based on the ECMA standards for C# and the Common Language Runtime."
pkg_upstream_url="http://www.mono-project.com/"

do_build() {
  ln -sf $(pkg_path_for core/coreutils)/bin/env /usr/bin/env
  ./autogen.sh --prefix=$pkg_prefix
  make get-monolite-latest
  make
}
