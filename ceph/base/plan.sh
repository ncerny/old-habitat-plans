pkg_name=base
pkg_origin=ceph
pkg_version="13.2.0"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=('LGPL-2.1')
pkg_filename="ceph-${pkg_name}_${pkg_version}-1bionic_amd64.deb"
pkg_source="https://download.ceph.com/debian-mimic/pool/main/c/ceph/${pkg_filename}"
pkg_shasum="595ad9268cc6160b403c1118a867e351832198e1efc15d51de3679b3fc064030"
pkg_deps=(
  core/glibc
  core/systemd
  core/python2
)
pkg_build_deps=(
  core/binutils
  core/tar
)
pkg_bin_dirs=(sbin usr/bin)
pkg_lib_dirs=(lib usr/lib usr/share)

do_unpack() {
  mkdir -p ${pkg_dirname}
  cd ${pkg_dirname}
  ar x ../${pkg_filename}
}

do_prepare() {
  return 0
}

do_build() {
  return 0
}

do_check() {
  return 0
}

do_install() {
  tar xf $HAB_CACHE_SRC_PATH/${pkg_name}-${pkg_version}/data.tar.xz -C ${pkg_prefix}
  fix_interpreter "${pkg_prefix}/usr/bin/ceph-detect-init" core/python2 bin/python
  fix_interpreter "${pkg_prefix}/usr/sbin/ceph-create-keys" core/python2 bin/python
}

do_strip() {
  return 0
}

do_end() {
  return 0
}
