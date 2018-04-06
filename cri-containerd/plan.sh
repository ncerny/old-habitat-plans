pkg_name=cri-containerd
pkg_origin=ncerny
pkg_version="1.0.0-beta.1"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=("Apache-2.0")
pkg_source="https://github.com/containerd/${pkg_name}/releases/download/v${pkg_version}/${pkg_name}-${pkg_version}.linux-amd64.tar.gz"
pkg_shasum="86b2415d9fe3b55ef72e290a7dd68adb956a5a8ab7ea58b4271348f30e23324e"
pkg_deps=(core/glibc)
pkg_build_deps=()
pkg_bin_dirs=(bin)
pkg_description="containerd is an industry-standard container runtime with an emphasis on simplicity, robustness and portability."
pkg_upstream_url="https://github.com/containerd/containerd"
pkg_svc_run="containerd --config $pkg_svc_config_path/containerd.toml"
pkg_svc_user="root"
pkg_svc_group=${pkg_svc_user}



do_unpack() {
    unpack_file $pkg_filename
}

do_build() {
  return 0
}

do_install() {
  mkdir -p $pkg_prefix/etc
  mkdir -p $pkg_prefix/opt
  mv $HAB_CACHE_SRC_PATH/etc/crictl.yaml $pkg_prefix/etc/crictl.yaml
  mv $HAB_CACHE_SRC_PATH/opt/cri-containerd $pkg_prefix/opt
  mv $HAB_CACHE_SRC_PATH/usr/local/bin/* $pkg_prefix/bin
  mv $HAB_CACHE_SRC_PATH/usr/local/sbin/* $pkg_prefix/bin
}
