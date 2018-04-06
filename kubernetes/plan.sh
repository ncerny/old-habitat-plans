pkg_name=kubernetes
pkg_origin=ncerny
pkg_version="1.9.3"
pkg_shasum="47e6043a880deb18340385c6c3f2482a5f4433769e2441a75e5892594d585cdd"
pkg_description="Production-Grade Container Scheduling and Management"
pkg_upstream_url="https://github.com/kubernetes/kubernetes"
pkg_license=('Apache-2.0')
pkg_source="https://github.com/kubernetes/kubernetes/archive/v${pkg_version}.tar.gz"

pkg_bin_dirs=(bin)

pkg_build_deps=(
  core/git
  core/make
  core/gcc
  core/go
  core/diffutils
  core/which
  core/rsync
)

pkg_deps=(
  core/glibc
)

do_build() {
  make
  return $?
}

do_install() {
  cp _output/bin/* "${pkg_prefix}/bin"
  return $?
}
