pkg_origin=ncerny
pkg_name=kubelet
pkg_version="1.10.4"
pkg_description="Production-Grade Container Scheduling and Management"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=('Apache-2.0')
pkg_deps=(ncerny/kubernetes/${pkg_version} ncerny/cni-plugins ncerny/cfssl)
pkg_svc_user="root"

do_build() {
  return 0
}

do_install() {
  return 0
}
