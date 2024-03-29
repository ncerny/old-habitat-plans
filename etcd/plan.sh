pkg_origin=ncerny
pkg_name=etcd
pkg_description="Distributed reliable key-value store for the most critical data of a distributed system"
pkg_version="v3.2.18"
pkg_shasum="b729db0732448064271ea6fdcb901773c4fe917763ca07776f22d0e5e0bd4097"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=('Apache-2.0')
pkg_deps=(core/glibc)
pkg_build_deps=(core/gnupg)
pkg_bin_dirs=(usr/bin)
pkg_svc_user="root"
pkg_source="https://github.com/coreos/etcd/releases/download/${pkg_version}/etcd-${pkg_version}-linux-amd64.tar.gz"
asc_source="${pkg_source}.asc"
pkg_filename="etcd-${pkg_version}-linux-amd64.tar.gz"
asc_filename="${pkg_filename}.asc"
asc_shasum="e48a7913b1aeef1a6f58133d9415e9df32bd6db2faa01a826c12ced4f51c29ce"
pkg_dirname="etcd-${pkg_version}-linux-amd64"
pkg_upstream_url="https://github.com/coreos/etcd/releases/"

do_download() {
  do_default_download

  download_file "${asc_source}" "${asc_filename}" "${pkg_asc_shasum}"
  download_file "https://coreos.com/dist/pubkeys/app-signing-pubkey.gpg" \
	        "app-signing-pubkey.gpg" \
          "16b93904e4b3133fe4b5f95f46e3db998c3b2f9d9cee6d4c2eb531f98028bcb3"
}

do_verify() {
  do_default_verify

  verify_file "${asc_filename}" "${asc_shasum}"
  verify_file "app-signing-pubkey.gpg" \
	      "16b93904e4b3133fe4b5f95f46e3db998c3b2f9d9cee6d4c2eb531f98028bcb3"

  # GPG verification
  build_line "Verifying ${pkg_name}-${pkg_version}-linux-amd64.tar.gz signature"
  GNUPGHOME=$(mktemp -d -p "$HAB_CACHE_SRC_PATH")
  gpg --import --keyid-format LONG "${HAB_CACHE_SRC_PATH}/app-signing-pubkey.gpg"
  gpg --batch --verify \
	"${HAB_CACHE_SRC_PATH}"/etcd-${pkg_version}-linux-amd64.tar.gz.asc \
        "${HAB_CACHE_SRC_PATH}"/etcd-${pkg_version}-linux-amd64.tar.gz
  rm -r "$GNUPGHOME"
  build_line "Signature verified for etcd-${pkg_version}-linux-amd64.tar.gz"
}

do_build() {
  return 0
}

do_install() {
  if [ ! -f "$pkg_prefix/etc/nsswitch.conf" ]; then
     mkdir "$pkg_prefix/etc/"
     touch "$pkg_prefix/etc/nsswitch.conf"
     echo "hosts: files dns" > "$pkg_prefix/etc/nsswitch.conf"
  fi

  mkdir -p "${pkg_prefix}/var/lib/etcd"
  install -v -D "$HAB_CACHE_SRC_PATH/$pkg_dirname/etcd" "$pkg_prefix/usr/bin/etcd"
  install -v -D "$HAB_CACHE_SRC_PATH/$pkg_dirname/etcdctl" "$pkg_prefix/usr/bin/etcdctl"
}

do_strip() {
  return 0
}
