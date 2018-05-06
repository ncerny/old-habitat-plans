pkg_name=containerd
pkg_description="containerd is an industry-standard container runtime with an emphasis on simplicity, robustness and portability."
pkg_upstream_url="https://github.com/containerd/containerd"
pkg_origin=ncerny
pkg_version="1.1.0-rc.2"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=("Apache-2.0")
pkg_source="https://github.com/containerd/${pkg_name}/releases/download/v${pkg_version}/${pkg_name}-${pkg_version}.linux-amd64.tar.gz"
pkg_shasum="013116ccc9c8a82cc342d55e0a0d5717d215cc54a3b4d9044c2769fc27544ad7"
pkg_dirname="bin"
pkg_deps=(core/glibc core/kmod core/runc)
pkg_build_deps=()
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_bin_dirs=(bin)
pkg_svc_user=root
pkg_svc_group=${pkg_svc_user}

do_unpack() {
    unpack_file $pkg_filename
}

do_build() {
  return 0
}

do_install() {
  mv $HAB_CACHE_SRC_PATH/$pkg_dirname/* $pkg_prefix/bin
}
