pkg_name=cfssl
pkg_origin=ncerny
pkg_version="R1.2"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=('Apache-2.0')
pkg_dirname="${pkg_name}-${pkg_version}"
pkg_deps=(core/glibc core/jq-static core/curl core/hab-butterfly)
pkg_bin_dirs=(bin)
pkg_description="CFSSL is CloudFlare's PKI/TLS swiss army knife."
pkg_upstream_url="https://github.com/cloudflare/cfssl"
declare -A pkg_files
pkg_files=(
  ["cfssl"]="eb34ab2179e0b67c29fd55f52422a94fe751527b06a403a79325fed7cf0145bd"
  ["cfssl-bundle"]="c0ad5348ede0b8038872bf06bab1f81657b710392371c5db10bd8372336ebd0f"
  ["cfssl-certinfo"]="ad395c35824bdff343189188658f15810d137c230463810026c6f04f3f78f08f"
  ["cfssl-newkey"]="eb58dfa8c8115b59f28d8444b1007c7be169814d24b8702d34dace3b208b3b20"
  ["cfssl-scan"]="1eb88a7898ac9006584fc689ff8c29f1ad9837d9fbf794fa7c62976fd8b490a3"
  ["cfssljson"]="1c9e628c3b86c3f2f8af56415d474c9ed4c8f9246630bd21c3418dbe5bf6401e"
  ["mkbundle"]="88f90fa9120662c3acdbbedd22306f4cf7ae71e9708838a6d5c8f1652b5bf747"
  ["multirootca"]="7b7884ae113eb7693591194399d424bd39902252c3198d6dea075ac98b3f275d"
)
pkg_exports=(
  [api]=api.port
)

pkg_exposes=(api)

do_download() {
  mkdir -p $HAB_CACHE_SRC_PATH/$pkg_dirname
  for file in ${!pkg_files[@]}; do
    download_file "https://pkg.cfssl.org/${pkg_version}/${file}_linux-amd64" "$file" "${pkg_files[$file]}"
  done
}

do_verify() {
  for file in ${!pkg_files[@]}; do
    verify_file "$file" "${pkg_files[$file]}"
  done
}

do_build() {
  return 0
}

do_install() {
  for file in ${!pkg_files[@]}; do
    install -v -D "$HAB_CACHE_SRC_PATH/$file" "$pkg_prefix/bin/$file"
  done
  for file in $(ls bin); do
    install -v -D "bin/$file" "$pkg_prefix/bin/$file"
  done
}

do_strip() {
  return 0
}
