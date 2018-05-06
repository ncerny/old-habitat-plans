pkg_origin=ncerny
pkg_name=kube-etcd
pkg_description="Distributed reliable key-value store for the most critical data of a distributed system"
pkg_version="1.10.2"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=('Apache-2.0')

case ${pkg_version%.*} in
  "1.9")
    etcd_pkg="etcd31"
    ;;
  "1.10")
    etcd_pkg="etcd32"
    ;;
  *)
    build_line "ERROR - Please check the etcd version dependency for this version of Kubernetes."
    exit 1
    ;;
esac

pkg_deps=(core/glibc core/curl ncerny/cfssl core/hab-butterfly core/openssl ncerny/${etcd_pkg})
pkg_bin_dirs=(usr/bin)
pkg_svc_user="root"

pkg_exports=(
  [client-port]=etcd-client-end
  [server-port]=etcd-server-end
)
pkg_exposes=(client-port server-port)

do_download() {
  return 0
}

do_build() {
  return 0
}

do_install() {
  return 0
}

do_strip() {
  return 0
}
