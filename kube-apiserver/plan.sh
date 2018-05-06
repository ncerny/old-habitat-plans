pkg_name=kube-apiserver
pkg_origin=ncerny
pkg_version="1.10.2"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=('Apache-2.0')
pkg_description="Production-Grade Container Scheduling and Management"
pkg_upstream_url=https://github.com/kubernetes/kubernetes
pkg_deps=(ncerny/kubernetes/${pkg_version} ncerny/cfssl)
pkg_binds=(
  [kvstore]="client-port"
)
pkg_exports=(
  [api-port]=secure-port
)
pkg_exposes=(api-port)

do_build(){
  return 0
}

do_install(){
  return 0
}
