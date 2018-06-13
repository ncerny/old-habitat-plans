pkg_name=kubernetes
pkg_origin=ncerny
pkg_version="1.10.4"
pkg_shasum="e2381459ba91674b5e5cc10c8e8d6dc910e71874d01165ca07a94188edc8505e"
pkg_description="Production-Grade Container Scheduling and Management"
pkg_upstream_url="https://github.com/kubernetes/kubernetes"
# https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.10.md#downloads-for-v1101
pkg_license=('Apache-2.0')
pkg_source="https://dl.k8s.io/v${pkg_version}/kubernetes-server-linux-amd64.tar.gz"
pkg_dirname=kubernetes
pkg_bin_dirs=(bin)

pkg_deps=(
  core/glibc
)

pkg_build_deps=(
  core/curl
)

do_before() {
  stable=$(curl -sSL https://dl.k8s.io/release/stable.txt)
  if [[ "$stable" != "v${pkg_version}" ]]; then
    build_line "ERROR: Latest Stable Version is ${stable}.  Please update the version, or set HAB_KUBE_VER_OVERIDE=true."
    if [[ ! "$HAB_KUBE_VER_OVERIDE" == "true" ]]; then
      exit 1
    fi
  fi
}

do_build() {
  return 0
}

do_install() {
  rm server/bin/*.tar server/bin/*.docker_tag
  cp server/bin/* "${pkg_prefix}/bin"
  return $?
}
