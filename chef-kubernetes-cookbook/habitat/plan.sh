pkg_name=kubernetes-cookbook
pkg_origin=ncerny
pkg_version=$(awk '/^version/ { ver=substr($2,2,length($2)-2); print ver }' ../metadata.rb)
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=("Apache-2.0")
pkg_deps=(ncerny/chef)
pkg_build_deps=(core/ruby24 ncerny/berkshelf)
pkg_lib_dirs=(cookbooks environments roles data_bags)
pkg_description="Deploy Kubernetes cluster using Habitat"
pkg_upstream_url="https://github.com/ncerny/kubernetes-cookbook"
pkg_svc_user=root
pkg_svc_group=root

do_download() {
  return 0
}

do_verify() {
  return 0
}

do_unpack() {
  return 0
}

do_build() {
  return 0
}

do_install() {
  export GEM_PATH=$(pkg_path_for "core/ruby24")/lib/ruby/2.4.0:$(pkg_path_for "ncerny/berkshelf")/lib/ruby/2.4.0
  berks update
  berks vendor cookbooks
  mv cookbooks $pkg_prefix
}

# Stubs
do_strip() {
  return 0
}
