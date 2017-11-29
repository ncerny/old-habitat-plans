pkg_name=common
pkg_origin=ceph
pkg_version="12.2.1"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=('LGPL-2.1')
pkg_source="http://download.ceph.com/tarballs/${pkg_origin}_${pkg_version}.orig.tar.gz"
# pkg_filename="${pkg_name}-${pkg_version}.tar.gz"
pkg_dirname=${pkg_origin}-${pkg_version}
pkg_shasum="512666ee88610640d66b261f9307c96ccd70eb25cd3349acd083fb1220c8a32e"
pkg_deps=(
  core/glibc
  core/systemd
  core/python2
)
pkg_build_deps=(
  core/make
  core/gcc
  core/git
  core/cmake
  core/libaio
  core/jemalloc
  core/zlib
  core/util-linux
  core/lz4
  core/leveldb
  core/snappy
  core/curl
  core/nss
  core/nspr
)

# pkg_lib_dirs=(lib)
# pkg_include_dirs=(include)
# pkg_bin_dirs=(bin)

# Optional.
# An array of paths, relative to the final install of the software, where
# pkg-config metadata (.pc files) can be found. Used to populate
# PKG_CONFIG_PATH for software that depends on your package.
# pkg_pconfig_dirs=(lib/pconfig)

# Optional.
# The command for the supervisor to execute when starting a service. You can
# omit this setting if your package is not intended to be run directly by a
# supervisor of if your plan contains a run hook in hooks/run.
# pkg_svc_run="bin/haproxy -f $pkg_svc_config_path/haproxy.conf"

# Optional.
# An associative array representing configuration data which should be gossiped to peers. The keys
# in this array represent the name the value will be assigned and the values represent the toml path
# to read the value.
# pkg_exports=(
#   [host]=srv.address
#   [port]=srv.port
#   [ssl-port]=srv.ssl.port
# )

# Optional.
# An array of `pkg_exports` keys containing default values for which ports that this package
# exposes. These values are used as sensible defaults for other tools. For example, when exporting
# a package to a container format.
# pkg_exposes=(port ssl-port)

# Optional.
# An associative array representing services which you depend on and the configuration keys that
# you expect the service to export (by their `pkg_exports`). These binds *must* be set for the
# supervisor to load the service. The loaded service will wait to run until it's bind becomes
# available. If the bind does not contain the expected keys, the service will not start
# successfully.
# pkg_binds=(
#   [database]="port host"
# )

# Optional.
# Same as `pkg_binds` but these represent optional services to connect to.
# pkg_binds_optional=(
#   [storage]="port host"
# )

# Optional.
# An array of interpreters used in shebang lines for scripts. Specify the
# subdirectory where the binary is relative to the package, for example,
# bin/bash or libexec/neverland, since binaries can be located in directories
# besides bin. This list of interpreters will be written to the metadata
# INTERPRETERS file, located inside a package, with their fully-qualified path.
# Then these can be used with the fix_interpreter function.
# pkg_interpreters=(bin/bash)

# Optional.
# The user to run the service as. The default is hab.
# pkg_svc_user="hab"

# Optional.
# The group to run the service as. The default is hab.
# pkg_svc_group="$pkg_svc_user"

# Required for core plans, optional otherwise.
# A short description of the package. It can be a simple string, or you can
# create a multi-line description using markdown to provide a rich description
# of your package.
# pkg_description="Some description."

# Required for core plans, optional otherwise.
# The project home page for the package.
# pkg_upstream_url="http://example.com/project-name"


# Callback Functions

do_begin() {
  return 0
}

do_download() {
  do_default_download
}

do_verify() {
  do_default_verify
}

do_clean() {
  do_default_clean
}

do_unpack() {
  do_default_unpack
}

do_prepare() {
  return 0
}

do_build() {
  pip install Cython
  ./do_cmake.sh
  cmake -DCMAKE_INSTALL_PREFIX:PATH=$pkg_prefix \
        -DWITH_MANPAGE=OFF \
        -DWITH_LZ4=ON \
        -DWITH_RDMA=OFF \
        -DWITH_OPENLDAP=OFF \
        -DWITH_LIBCEPHFS=OFF \
        -DWITH_KRBD=OFF \
        -DWITH_RADOSGW=OFF \
        -DWITH_LTTNG=OFF \
        -DWITH_BABELTRACE=OFF \
        -DWITH_FUSE=OFF \
        -DUDEV_LIBRARIES=$(pkg_path_for core/systemd)/lib \
        -DUDEV_INCLUDE_DIR=$(pkg_path_for core/systemd)/include \
        -DAIO_LIBRARIES=$(pkg_path_for core/libaio)/lib \
        -DAIO_INCLUDE_DIR=$(pkg_path_for core/libaio)/include \
        -DBLKID_LIBRARIES=$(pkg_path_for core/util-linux)/lib \
        -DBLKID_INCLUDE_DIR=$(pkg_path_for core/util-linux)/include \
        -DLEVELDB_LIBRARIES=$(pkg_path_for core/leveldb)/lib \
        -DLEVELDB_INCLUDE_DIR=$(pkg_path_for core/leveldb)/include \
        -DSNAPPY_LIBRARIES=$(pkg_path_for core/snappy)/lib \
        -DSNAPPY_INCLUDE_DIR=$(pkg_path_for core/snappy)/include \
        -DLZ4_LIBRARY=$(pkg_path_for core/lz4)/lib \
        -DLZ4_INCLUDE_DIR=$(pkg_path_for core/lz4)/include \
        -DJEMALLOC_LIBRARIES=$(pkg_path_for core/jemalloc)/lib \
        -DJEMALLOC_INCLUDE_DIR=$(pkg_path_for core/jemalloc)/include \
        -DCURL_LIBRARY=$(pkg_path_for core/curl)/lib \
        -DCURL_INCLUDE_DIR=$(pkg_path_for core/curl)/include \
        -DNSS_LIBRARIES=$(pkg_path_for core/nss)/lib \
        -DNSS_INCLUDE_DIRS=$(pkg_path_for core/nss)/include \
        -DNSPR_LIBRARIES=$(pkg_path_for core/nspr)/lib \
        -DNSPR_INCLUDE_DIRS=$(pkg_path_for core/nspr)/include \
        -DZLIB_LIBRARY=$(pkg_path_for core/zlib)/lib \
        -DZLIB_INCLUDE_DIR=$(pkg_path_for core/zlib)/include \
        -DBoost_INCLUDE_DIR=$(pkg_path_for core/boost)/include \
        -DBoost_LIBRARY=$(pkg_path_for core/boost)/lib \
        -DPYTHON_INCLUDE_DIR=$(pkg_path_for core/python2)/include \
        -DPYTHON_LIBRARY=$(pkg_path_for core/python2)/lib
  make common
  # do_default_build
}

do_check() {
  return 0
}

do_install() {
  do_default_install
}

do_strip() {
  do_default_strip
}

do_end() {
  return 0
}
