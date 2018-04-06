pkg_name=cni-plugins
pkg_origin=ncerny
pkg_version="0.7.0"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=("Apache-2.0")
pkg_source="https://github.com/containernetworking/plugins/releases/download/v${pkg_version}/${pkg_name}-amd64-v${pkg_version}.tgz"
pkg_shasum="c276f5f39f31cc9fa83ce69bebcbea5876778ccc081786d45934a59ef015c5c5"
pkg_deps=(core/glibc)
pkg_description="Some CNI network plugins, maintained by the containernetworking team."
pkg_upstream_url="https://github.com/containernetworking/plugins"

do_build() {
  return 0
}

do_build() {
  return 0
}

do_install() {
  for bin in bridge flannel host-local loopback portmap sample vlan dhcp host-device ipvlan macvlan ptp tuning; do
    install -v -D "$HAB_CACHE_SRC_PATH/$bin" "$pkg_prefix/bin/$bin"
    rm "$HAB_CACHE_SRC_PATH/$bin"
  done
}
