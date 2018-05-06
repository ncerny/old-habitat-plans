pkg_origin=ncerny
pkg_name=kubelet
pkg_version="1.10.2"
pkg_description="Production-Grade Container Scheduling and Management"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=('Apache-2.0')
pkg_deps=(ncerny/kubernetes/${pkg_version} ncerny/cni-plugins ncerny/cfssl core/bash)
pkg_svc_user="root"
pkg_binds=(
  [apiserver]="api-port"
)
do_build() {
  return 0
}

do_install() {
  return 0
}
